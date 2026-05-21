/* ============================================================
   English Learning Engine v1 — Shared Logic
   Depends on: topics.js (window.ELV1_TOPICS), profile.js (window.ELV1_PROFILE)
   ============================================================ */
(function (global) {
'use strict';

const T = global.ELV1_TOPICS;
const P = global.ELV1_PROFILE;

if (!T || !P) {
  console.error('[ELV1] topics.js veya profile.js yüklenmedi.');
  return;
}

const STORE_PREFIX = (P.engine_settings && P.engine_settings.storage_prefix) || 'elv1_';

/* ---------- STORAGE ---------- */
function lsGet(key, fallback) {
  try {
    const raw = localStorage.getItem(STORE_PREFIX + key);
    return raw ? JSON.parse(raw) : fallback;
  } catch (e) { return fallback; }
}
function lsSet(key, value) {
  try { localStorage.setItem(STORE_PREFIX + key, JSON.stringify(value)); }
  catch (e) { console.warn('[ELV1] localStorage write fail', e); }
}

/* ---------- DATE ---------- */
function todayISO() {
  const d = new Date();
  return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
}
function nowTag() {
  const d = new Date();
  const p = n => String(n).padStart(2, '0');
  return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()) + '-' + p(d.getHours()) + p(d.getMinutes());
}
function daysBetween(iso) {
  if (!iso) return 9999;
  const d = new Date(iso);
  const today = new Date(todayISO());
  return Math.round((today - d) / 86400000);
}

/* ---------- ROTATION ----------
   Her gün, motor açıldığında 6-8 konu seçer. Aynı gün her iki motor
   açılırsa aynı set döner (cross-confirmation).
   Seçim mantığı:
     1. weak-topics localStorage'dan zorunlu girişler
     2. Borç skoru en yüksek olanlar (uzun süredir dokunulmamış + zayıf)
     3. Kategori başına maks 2
     4. Toplam 6-8 (default 7)
------------------------------ */
function getTopicProgress() {
  return lsGet('topic_progress', {}); // { slug: {sessions, last_date, last_scores:[...], strength} }
}
function setTopicProgress(p) { lsSet('topic_progress', p); }

function computeStrength(scores) {
  // scores: [{date, correct, total}, ...] most-recent first
  if (!scores || !scores.length) return null;
  const last = scores.slice(0, 3);
  const w = [3, 2, 1];
  let num = 0, den = 0;
  last.forEach((s, i) => {
    const wi = w[i] || 1;
    const pct = s.total > 0 ? (s.correct / s.total) * 100 : 0;
    num += pct * wi; den += wi;
  });
  return den ? Math.round(num / den) : null;
}
function computeDebt(prog) {
  const days = prog.last_date ? daysBetween(prog.last_date) : 30;
  const weakness = prog.strength == null ? 100 : (100 - prog.strength);
  return Math.round((days * weakness) / 100);
}

function getDailyTopics(engineTag) {
  // localStorage-cached so both motors get same set on same day
  const cacheKey = 'daily_topics_' + todayISO();
  const cached = lsGet(cacheKey, null);
  if (cached && Array.isArray(cached) && cached.length) return cached;

  const prog = getTopicProgress();
  const all = T.topics.slice();

  // 1) weak-topics zorunlu
  const weak = lsGet('weak_topics', []); // [{slug, ...}]
  const must = new Set(weak.map(w => w.slug));

  // 2) Skorla: borç skoru
  const scored = all.map(t => {
    const p = prog[t.slug] || {};
    const debt = computeDebt(p);
    return { ...t, _debt: debt, _strength: p.strength };
  }).sort((a, b) => b._debt - a._debt);

  // 3) Seçim
  const target = 7; // default; user can re-roll to get 6 or 8
  const picked = [];
  const catCount = {};
  // önce zorunlu olanları al
  scored.forEach(t => {
    if (must.has(t.slug) && picked.length < target) {
      picked.push(t);
      catCount[t.category] = (catCount[t.category] || 0) + 1;
    }
  });
  // sonra borca göre, kategori sınırı koru
  scored.forEach(t => {
    if (picked.length >= target) return;
    if (picked.find(p => p.slug === t.slug)) return;
    const c = catCount[t.category] || 0;
    if (c >= (P.rotation_rules.max_per_category || 2)) return;
    picked.push(t);
    catCount[t.category] = c + 1;
  });
  // doldurma (kategori sınırı esnek)
  scored.forEach(t => {
    if (picked.length >= target) return;
    if (picked.find(p => p.slug === t.slug)) return;
    picked.push(t);
  });

  // cache
  lsSet(cacheKey, picked);
  return picked;
}

function rerollDailyTopics() {
  const k = 'daily_topics_' + todayISO();
  try { localStorage.removeItem(STORE_PREFIX + k); } catch (e) {}
  return getDailyTopics();
}

/* ---------- SESSION RESULT ---------- */
function recordTopicResult(slug, correct, total, errors) {
  const prog = getTopicProgress();
  const p = prog[slug] || { sessions: 0, last_scores: [] };
  p.sessions = (p.sessions || 0) + 1;
  p.last_date = todayISO();
  p.last_scores = [{ date: todayISO(), correct, total, errors: errors || [] }].concat(p.last_scores || []).slice(0, 10);
  p.strength = computeStrength(p.last_scores);
  prog[slug] = p;
  setTopicProgress(prog);
  return p;
}

function buildSessionPayload(engineTag, sessionTopics, perTopicResults, durationSec) {
  const sessionId = nowTag() + '-' + engineTag;
  const payload = sessionTopics.map(t => {
    const r = perTopicResults[t.slug] || { correct: 0, total: 0, errors: [] };
    return {
      slug: t.slug,
      name: t.name,
      cefr: t.cefr,
      category: t.category,
      correct: r.correct,
      total: r.total,
      score_pct: r.total ? Math.round((r.correct / r.total) * 100) : null,
      errors: r.errors,
      subpatterns_touched: r.subpatterns_touched || []
    };
  });
  return {
    schema_version: '1.0',
    type: engineTag === 'grammar-first' ? 'session_grammar_first' : 'session_text_first',
    timestamp: new Date().toISOString(),
    engine: engineTag,
    session_id: sessionId,
    duration_sec: durationSec || null,
    payload: payload
  };
}

/* ---------- WORD BANK ---------- */
function getWordBank() { return lsGet('word_bank', []); }
function setWordBank(b) { lsSet('word_bank', b); }
function saveToWordBank(item) {
  // item: {item, type (word|phrasal_verb|chunk), definition_en, definition_tr, example, source}
  const bank = getWordBank();
  const key = (item.item || '').trim().toLowerCase();
  if (!key) return false;
  const exists = bank.find(b => b.item.toLowerCase() === key && b.type === item.type);
  if (exists) {
    exists.last_seen = todayISO();
    exists.frequency = (exists.frequency || 1) + 1;
  } else {
    bank.push({
      item: item.item,
      type: item.type || 'word',
      definition_en: item.definition_en || '',
      definition_tr: item.definition_tr || '',
      example: item.example || '',
      source: item.source || {},
      first_seen: todayISO(),
      last_seen: todayISO(),
      frequency: 1,
      status: 'new',
      srs: null  // SM-2 state set on first review
    });
  }
  setWordBank(bank);
  return true;
}

function buildBankAddPayload(addedItems, engineTag, sessionId) {
  return {
    schema_version: '1.0',
    type: 'word_bank_add',
    timestamp: new Date().toISOString(),
    engine: engineTag,
    session_id: sessionId || null,
    payload: addedItems
  };
}

/* ---------- SRS (SM-2 simplified) ---------- */
function srsInit() {
  return { repetition: 0, interval: 0, ef: 2.5, due_date: todayISO() };
}
function srsReview(card, quality) {
  // quality: 0 (again) / 3 (hard) / 4 (good) / 5 (easy)
  const s = card.srs || srsInit();
  if (quality === 0) {
    s.repetition = 0;
    s.interval = 1;
    s.ef = Math.max(1.3, s.ef - 0.20);
    card._again_count = (card._again_count || 0) + 1;
  } else {
    if (s.repetition === 0) {
      s.interval = 1;
    } else if (s.repetition === 1) {
      s.interval = 6;
    } else {
      if (quality === 3) s.interval = Math.round(s.interval * 1.2);
      else if (quality === 4) s.interval = Math.round(s.interval * s.ef);
      else if (quality === 5) s.interval = Math.round(s.interval * s.ef * 1.3);
    }
    s.repetition += 1;
    if (quality === 3) s.ef = Math.max(1.3, s.ef - 0.15);
    else if (quality === 5) s.ef = s.ef + 0.10;
    // good (4) leaves ef alone
  }
  // due_date = today + interval days
  const d = new Date();
  d.setDate(d.getDate() + s.interval);
  s.due_date = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  // status update
  if (card._again_count >= 8) card.status = 'leech';
  else if (s.interval > 30) card.status = 'mature';
  else if (s.interval >= 7) card.status = 'young';
  else card.status = 'learning';
  card.srs = s;
  return card;
}
function srsDueCards() {
  const bank = getWordBank();
  return bank.filter(c => {
    if (c.status === 'suspended') return false;
    if (!c.srs) return true; // new
    return c.srs.due_date <= todayISO();
  });
}

/* ---------- EXPORT TO FILE ---------- */
function downloadJSON(payload, suggestedName) {
  const blob = new Blob([JSON.stringify(payload, null, 2)], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = suggestedName || (nowTag() + '-' + (payload.engine || 'session') + '.json');
  document.body.appendChild(a);
  a.click();
  setTimeout(() => { URL.revokeObjectURL(url); a.remove(); }, 100);
}

/* ---------- QUIZ GENERATION (per topic) ---------- */
function genQuizForTopic(topic, count) {
  // Production-grade item gen is heavy; we provide template-based fallbacks
  // each topic exposes examples + common_errors; we generate:
  //  - MCQ (form recognition)
  //  - Fill-in (formula slot)
  //  - Transformation (error-correction style)
  const items = [];
  const exs = topic.examples || [];
  const errs = topic.common_errors || [];
  count = count || 3;

  // 1) MCQ: pick correct example, distractor from a different topic with mangled tense
  if (exs.length) {
    const correct = exs[0].en;
    const wrong1 = correct.replace(/\bhas\b|\bhave\b/i, 'will').replace(/\bis\b/, 'was');
    const wrong2 = correct.replace(/\bthe\b/, 'a').replace(/\bof\b/, 'in');
    const opts = shuffle([correct, wrong1 !== correct ? wrong1 : correct + ' (alt)', wrong2 !== correct ? wrong2 : 'None'].filter((v, i, a) => a.indexOf(v) === i));
    while (opts.length < 3) opts.push('— (no match) —');
    items.push({
      type: 'mcq',
      prompt: 'Hangisi ' + topic.name + ' yapısına uygun?',
      tr_hint: topic.tr_bridge,
      options: opts.slice(0, 4),
      answer: correct,
      topic_slug: topic.slug,
      subpattern: (topic.subpatterns || [])[0] || null
    });
  }

  // 2) Fill-in: use formula as hint
  if (exs.length >= 1) {
    const ex = exs[Math.floor(Math.random() * exs.length)];
    const words = ex.en.split(' ');
    const blankIdx = Math.max(1, Math.min(words.length - 2, Math.floor(words.length / 2)));
    const answer = words[blankIdx];
    const prompt = words.map((w, i) => i === blankIdx ? '____' : w).join(' ');
    items.push({
      type: 'fill',
      prompt: prompt,
      tr: ex.tr,
      formula_hint: topic.formula,
      answer: answer.replace(/[.,;:!?]$/, ''),
      topic_slug: topic.slug
    });
  }

  // 3) Error correction (if common_errors available)
  if (errs.length) {
    items.push({
      type: 'errspot',
      prompt: 'Bu cümlede yaygın hata nedir? (' + topic.name + ')',
      hint: errs[0],
      free_text: true,
      topic_slug: topic.slug
    });
  }

  return items.slice(0, count);
}
function shuffle(arr) {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

/* ---------- TEXT GENERATION HELPER ----------
   Motor B (text-first) için: gün konularını referans alarak küçük bir
   bağlam paragrafı üretir. Tam jeneratif değil — profile.json'daki
   anchor'lardan örüntü kurar. Profil-uyumlu bağlam, gramerin
   data-g="N" işaretlemesiyle gelir.
------------------------------ */
function buildTextFirstPassage(dailyTopics) {
  // Profile-relevant short paragraph composed from per-topic examples
  // Her gün konusunun ikinci örneği veya ilk örneği bağlam cümlesi olur,
  // önüne küçük geçiş ekler. Çıktı: { html, breakdown: [{slug, sentence, span_idx}] }
  const intro = "Bir notebook'un sayfası önünde, dünün okumalarından bir kalıp damıtmaya çalışıyorum.";
  const sentences = [];
  const breakdown = [];
  dailyTopics.forEach((t, i) => {
    const ex = (t.examples || [])[i % (t.examples || []).length || 0] || t.examples[0];
    if (!ex) return;
    const gIdx = (i % 8) + 1;
    const wrapped = `<span data-g="${gIdx}" data-slug="${t.slug}" title="${escapeHTML(t.name)}">${escapeHTML(ex.en)}</span>`;
    sentences.push(wrapped);
    breakdown.push({ slug: t.slug, name: t.name, sentence: ex.en, tr: ex.tr, gIdx: gIdx });
  });
  const html = `<p>${escapeHTML(intro)}</p><p>${sentences.join(' ')}</p>`;
  return { html, breakdown };
}
function escapeHTML(s) {
  return String(s || '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

/* ---------- BANK BUTTON (UI helper) ---------- */
function attachBankButton(buttonEl, itemData) {
  buttonEl.addEventListener('click', e => {
    e.stopPropagation();
    saveToWordBank(itemData);
    buttonEl.classList.add('saved');
    buttonEl.textContent = '💾 Kaydedildi';
    // Toast
    showToast(`"${itemData.item}" word bank'a eklendi.`);
  });
}
function showToast(msg, ms) {
  let t = document.getElementById('el-toast');
  if (!t) {
    t = document.createElement('div');
    t.id = 'el-toast';
    t.style.cssText = 'position:fixed;bottom:20px;left:50%;transform:translateX(-50%);background:#1a2d4a;border:1px solid #243050;color:#dde3f0;padding:10px 18px;border-radius:8px;font-family:Verdana;font-size:12px;z-index:9999;box-shadow:0 4px 18px rgba(0,0,0,.5);opacity:0;transition:opacity .3s;';
    document.body.appendChild(t);
  }
  t.textContent = msg;
  t.style.opacity = '1';
  clearTimeout(t._timer);
  t._timer = setTimeout(() => { t.style.opacity = '0'; }, ms || 2400);
}

/* ---------- HEADER (shared rendering) ---------- */
function renderHeader(opts) {
  // opts: { title, subtitle, engineTag, onExport, onReroll }
  const el = document.createElement('header');
  el.className = 'el-header';
  el.innerHTML = `
    <span class="el-logo">EL·v1</span>
    <span class="el-sub">${escapeHTML(opts.title)} <small style="color:var(--text3)">— ${escapeHTML(opts.subtitle || '')}</small></span>
    <span class="el-meta-chip" id="el-day-chip">📅 ${todayISO()}</span>
    <span class="el-meta-chip" id="el-topics-chip" style="background:rgba(251,191,36,.10);border-color:rgba(251,191,36,.25);color:var(--accent3);">🎯 — konu</span>
    <div class="el-toolbar">
      ${opts.onReroll ? '<button class="el-btn" id="el-reroll" title="Bugünün konularını yeniden seç">🎲 Reroll</button>' : ''}
      <button class="el-btn" id="el-theme" title="Tema değiştir">🌓</button>
      <button class="el-btn" id="el-fs" title="Font boyutu">A</button>
      <button class="el-btn primary" id="el-export" title="Sonuçları JSON olarak indir">📥 Vault'a İndir</button>
    </div>
  `;
  return el;
}
function attachHeaderActions(headerEl, opts) {
  const themes = ['', 'theme-light', 'theme-forest', 'theme-sunset'];
  const fsList = ['fs-s', 'fs-m', 'fs-l', 'fs-xl'];
  let ti = 0, fi = 1;
  document.body.classList.add(fsList[fi]);

  const themeBtn = headerEl.querySelector('#el-theme');
  if (themeBtn) themeBtn.addEventListener('click', () => {
    themes.forEach(t => t && document.body.classList.remove(t));
    ti = (ti + 1) % themes.length;
    if (themes[ti]) document.body.classList.add(themes[ti]);
  });
  const fsBtn = headerEl.querySelector('#el-fs');
  if (fsBtn) fsBtn.addEventListener('click', () => {
    fsList.forEach(c => document.body.classList.remove(c));
    fi = (fi + 1) % fsList.length;
    document.body.classList.add(fsList[fi]);
  });
  const expBtn = headerEl.querySelector('#el-export');
  if (expBtn && opts.onExport) expBtn.addEventListener('click', opts.onExport);
  const rollBtn = headerEl.querySelector('#el-reroll');
  if (rollBtn && opts.onReroll) rollBtn.addEventListener('click', opts.onReroll);
}

/* ---------- PUBLIC API ---------- */
global.ELV1 = {
  T, P,
  todayISO, nowTag, daysBetween,
  lsGet, lsSet,
  getDailyTopics, rerollDailyTopics,
  recordTopicResult, getTopicProgress,
  buildSessionPayload,
  getWordBank, setWordBank, saveToWordBank, buildBankAddPayload,
  srsInit, srsReview, srsDueCards,
  downloadJSON,
  genQuizForTopic, buildTextFirstPassage, shuffle,
  attachBankButton, showToast,
  renderHeader, attachHeaderActions,
  escapeHTML
};

})(typeof window !== 'undefined' ? window : globalThis);
