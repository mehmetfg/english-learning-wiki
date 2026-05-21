window.ELV1_PROFILE = 
{
  "schema_version": "1.0",
  "updated": "2026-05-18",
  "user": {
    "target_cefr": "B2",
    "current_estimated_cefr": "B1",
    "native_language": "tr",
    "daily_minutes_target": 45,
    "voice_friction": "medium"
  },
  "interest_domains": [
    {
      "slug": "philosophy",
      "name": "Felsefe",
      "weight": 0.25,
      "anchors": ["Descartes", "Stoicism", "Naval", "Cogito", "Meditations", "equanimity"]
    },
    {
      "slug": "writing",
      "name": "Yazarlık",
      "weight": 0.25,
      "anchors": ["Paul Graham", "essays", "clarity", "voice", "rewriting", "true and novel"]
    },
    {
      "slug": "finance",
      "name": "Finans / Yatırım",
      "weight": 0.15,
      "anchors": ["compound interest", "Buffett", "assets vs liabilities", "rat race", "patience"]
    },
    {
      "slug": "ai",
      "name": "AI / Teknoloji",
      "weight": 0.15,
      "anchors": ["LLM", "hallucination", "automation", "leverage", "code as media"]
    },
    {
      "slug": "psychology",
      "name": "Psikoloji",
      "weight": 0.10,
      "anchors": ["loss aversion", "Kahneman", "System 1/2", "habits", "ego depletion"]
    },
    {
      "slug": "literature",
      "name": "Edebiyat",
      "weight": 0.10,
      "anchors": ["Joyce", "Hugo", "Dostoevsky", "Cervantes", "Bloomsday"]
    }
  ],
  "rotation_rules": {
    "topics_per_session": [6, 8],
    "max_per_category": 2,
    "force_monthly_coverage": true,
    "weak_topics_priority": true,
    "rehearsal_allowed_same_day": true,
    "min_days_before_repeat_unless_weak": 4
  },
  "engine_settings": {
    "default_theme": "dark",
    "default_font_size": "m",
    "default_tts_rate": 0.95,
    "storage_prefix": "elv1_",
    "session_id_format": "YYYY-MM-DD-HHmm-{engine}"
  }
}
;
