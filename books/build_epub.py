#!/usr/bin/env python3
"""Kitap kaynak klasöründeki düz metin bölümlerden TTS dostu EPUB 3 üretir.
Kaynak biçimi: '# ' bölüm başlığı, '## ' alt başlık, boş satır paragraf ayırır."""
import sys, os, re, uuid, zipfile, json, html, datetime
from PIL import Image, ImageDraw, ImageFont

FONT_B = "/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf"
FONT_R = "/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf"

def wrap(draw, text, font, maxw):
    words, lines, cur = text.split(), [], ""
    for w in words:
        t = (cur + " " + w).strip()
        if draw.textlength(t, font=font) <= maxw: cur = t
        else: lines.append(cur); cur = w
    if cur: lines.append(cur)
    return lines

def make_cover(meta, path):
    W, H = 1600, 2400
    c1, c2, acc = [tuple(x) for x in meta["colors"]]
    img = Image.new("RGB", (W, H), c1)
    d = ImageDraw.Draw(img)
    for y in range(H):
        t = y / H
        d.line([(0, y), (W, y)], fill=tuple(int(c1[i]*(1-t)+c2[i]*t) for i in range(3)))
    d.rectangle([70, 70, W-70, H-70], outline=acc, width=6)
    d.rectangle([95, 95, W-95, H-95], outline=acc, width=2)
    # motif
    cx, cy = W//2, 1500
    for r in range(80, 420, 55):
        d.ellipse([cx-r, cy-r, cx+r, cy+r], outline=acc, width=3)
    ft = ImageFont.truetype(FONT_B, 150)
    fs = ImageFont.truetype(FONT_R, 64)
    fa = ImageFont.truetype(FONT_B, 70)
    y = 300
    for ln in wrap(d, meta["title"].upper(), ft, W-300):
        w = d.textlength(ln, font=ft); d.text(((W-w)/2, y), ln, font=ft, fill=(250, 245, 230)); y += 175
    y += 40
    d.line([(W/2-250, y), (W/2+250, y)], fill=acc, width=5); y += 60
    for ln in wrap(d, meta["subtitle"], fs, W-340):
        w = d.textlength(ln, font=fs); d.text(((W-w)/2, y), ln, font=fs, fill=(235, 228, 210)); y += 85
    w = d.textlength(meta["author"], font=fa)
    d.text(((W-w)/2, H-300), meta["author"], font=fa, fill=acc)
    img.save(path, "JPEG", quality=90)

def esc(s): return html.escape(s, quote=False)

def parse(path):
    txt = open(path, encoding="utf-8").read().strip()
    title, body, secs, n = None, [], [], 0
    for block in re.split(r"\n\s*\n", txt):
        b = " ".join(block.split())
        if b.startswith("## "):
            n += 1; sid = f"s{n}"; secs.append((sid, b[3:]))
            body.append(f'<h2 id="{sid}">{esc(b[3:])}</h2>')
        elif b.startswith("# "):
            title = b[2:]; body.append(f"<h1>{esc(title)}</h1>")
        else:
            body.append(f"<p>{esc(b)}</p>")
    return title, "\n".join(body), secs, len(txt.split())

def page(title, body, lang):
    return f'''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="{lang}" lang="{lang}">
<head><meta charset="utf-8"/><title>{esc(title)}</title><link rel="stylesheet" type="text/css" href="style.css"/></head>
<body>
{body}
</body>
</html>'''

CSS = """body{font-family:serif;line-height:1.6;margin:0 5%;}
h1{text-align:center;margin:2em 0 1.2em;font-size:1.6em;}
h2{margin:1.6em 0 0.6em;font-size:1.2em;}
p{text-indent:1.2em;margin:0 0 0.5em;text-align:justify;}
.cover{text-align:center;margin:0;padding:0;} .cover img{max-width:100%;max-height:100%;}
nav ol{list-style:none;padding-left:1em;} nav li{margin:0.3em 0;}"""

def build(src):
    meta = json.load(open(os.path.join(src, "meta.json"), encoding="utf-8"))
    lang = "tr"
    files = sorted(f for f in os.listdir(src) if re.match(r"\d\d.*\.txt$", f))
    chapters, total = [], 0
    for i, f in enumerate(files, 1):
        t, body, secs, wc = parse(os.path.join(src, f)); total += wc
        chapters.append((f"bolum{i:02d}.xhtml", t, body, secs))
    out = os.path.join(os.path.dirname(src.rstrip("/")), meta["file"])
    cover = os.path.join(src, "cover.jpg"); make_cover(meta, cover)
    bid = "urn:uuid:" + str(uuid.uuid5(uuid.NAMESPACE_URL, meta["title"]))
    now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    z = zipfile.ZipFile(out, "w")
    z.writestr(zipfile.ZipInfo("mimetype"), "application/epub+zip", compress_type=zipfile.ZIP_STORED)
    def w(n, s): z.writestr(n, s, compress_type=zipfile.ZIP_DEFLATED)
    w("META-INF/container.xml", '<?xml version="1.0"?><container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"><rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles></container>')
    w("OEBPS/style.css", CSS)
    z.write(cover, "OEBPS/cover.jpg", compress_type=zipfile.ZIP_STORED)
    w("OEBPS/cover.xhtml", page(meta["title"], f'<div class="cover"><img src="cover.jpg" alt="{esc(meta["title"])}, {esc(meta["subtitle"])}"/></div>', lang))
    title_body = f'<h1>{esc(meta["title"])}</h1><p style="text-align:center;text-indent:0">{esc(meta["subtitle"])}</p><p style="text-align:center;text-indent:0">{esc(meta["author"])}</p>'
    w("OEBPS/title.xhtml", page(meta["title"], title_body, lang))
    # içindekiler (görünür dizin + nav)
    items = []
    for fn, t, _, secs in chapters:
        sub = "".join(f'<li><a href="{fn}#{sid}">{esc(st)}</a></li>' for sid, st in secs)
        items.append(f'<li><a href="{fn}">{esc(t)}</a>' + (f"<ol>{sub}</ol>" if sub else "") + "</li>")
    nav = f'<nav epub:type="toc" id="toc"><h1>İçindekiler</h1><ol>{"".join(items)}</ol></nav><nav epub:type="landmarks" hidden=""><ol><li><a epub:type="cover" href="cover.xhtml">Kapak</a></li><li><a epub:type="toc" href="nav.xhtml">İçindekiler</a></li><li><a epub:type="bodymatter" href="{chapters[0][0]}">Başlangıç</a></li></ol></nav>'
    w("OEBPS/nav.xhtml", page("İçindekiler", nav, lang))
    for fn, t, body, _ in chapters: w("OEBPS/" + fn, page(t, body, lang))
    # NCX (eski okuyucular için)
    np, pts = 0, []
    for fn, t, _, secs in chapters:
        np += 1; sp = []
        for sid, st in secs:
            np += 1; sp.append(f'<navPoint id="n{np}" playOrder="{np}"><navLabel><text>{esc(st)}</text></navLabel><content src="{fn}#{sid}"/></navPoint>')
        pts.append(f'<navPoint id="c{fn[5:7]}" playOrder="{np-len(secs)}"><navLabel><text>{esc(t)}</text></navLabel><content src="{fn}"/>{"".join(sp)}</navPoint>')
    w("OEBPS/toc.ncx", f'<?xml version="1.0" encoding="utf-8"?><ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1"><head><meta name="dtb:uid" content="{bid}"/></head><docTitle><text>{esc(meta["title"])}</text></docTitle><navMap>{"".join(pts)}</navMap></ncx>')
    man = ['<item id="css" href="style.css" media-type="text/css"/>',
           '<item id="cover-image" href="cover.jpg" media-type="image/jpeg" properties="cover-image"/>',
           '<item id="cover" href="cover.xhtml" media-type="application/xhtml+xml"/>',
           '<item id="title" href="title.xhtml" media-type="application/xhtml+xml"/>',
           '<item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>',
           '<item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>']
    spine = ['<itemref idref="cover" linear="yes"/>', '<itemref idref="title"/>', '<itemref idref="nav"/>']
    for fn, *_ in chapters:
        i = fn[:-6]; man.append(f'<item id="{i}" href="{fn}" media-type="application/xhtml+xml"/>'); spine.append(f'<itemref idref="{i}"/>')
    opf = f'''<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="bookid" xml:lang="tr">
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
<dc:identifier id="bookid">{bid}</dc:identifier><dc:title>{esc(meta["title"])}</dc:title>
<dc:creator>{esc(meta["author"])}</dc:creator><dc:language>tr</dc:language>
<dc:description>{esc(meta["subtitle"])}</dc:description>
<meta property="dcterms:modified">{now}</meta><meta name="cover" content="cover-image"/>
<meta property="schema:accessMode">textual</meta><meta property="schema:accessibilityFeature">tableOfContents</meta>
</metadata>
<manifest>{"".join(man)}</manifest>
<spine toc="ncx">{"".join(spine)}</spine>
<guide><reference type="cover" title="Kapak" href="cover.xhtml"/><reference type="toc" title="İçindekiler" href="nav.xhtml"/></guide>
</package>'''
    w("OEBPS/content.opf", opf)
    z.close()
    print(f"{out}: {len(chapters)} bölüm, {total} kelime, yaklaşık {total//230} sayfa")

if __name__ == "__main__":
    for s in sys.argv[1:]: build(s)
