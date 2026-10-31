"""Vade uygulama ikonunu üretir (düz, tek renk).

Tek renk zemin üzerinde beyaz tek sembol: tepesinde kronometre başlığı olan, sağ üstü açık bir
geri sayım halkası (vade) ve uzun kolu o boşluktan çıkan onay işareti. Onay işareti aynı zamanda
Vade'nin "V" harfidir.

Kullanım: python3 make_icon.py <AppIcon.appiconset klasörü> [renk: teal|navy]
"""
import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw

S = 4096  # 4 kat büyük çizip küçültüyoruz; kenarlar yumuşak çıkar.
COLORS = {"teal": (13, 148, 136), "navy": (23, 37, 84)}
MARK = (255, 255, 255)


def round_line(draw, points, width, fill):
    draw.line(points, fill=fill, width=int(width), joint="curve")
    for x, y in (points[0], points[-1]):
        draw.ellipse([x - width / 2, y - width / 2, x + width / 2, y + width / 2], fill=fill)


def artwork(size, background):
    k = size / 1024
    img = Image.new("RGB", (size, size), background)
    d = ImageDraw.Draw(img)

    # Halka: saat 3'ten başlayıp saat yönünde saat 12'ye kadar (sağ üst çeyrek açık).
    cx, cy, r, w = 500 * k, 566 * k, 272 * k, 70 * k
    d.arc([cx - r, cy - r, cx + r, cy + r], start=0, end=270, fill=MARK, width=int(w))
    for angle in (0, 270):
        a = math.radians(angle)
        ex, ey = cx + (r - w / 2) * math.cos(a), cy + (r - w / 2) * math.sin(a)
        d.ellipse([ex - w / 2, ey - w / 2, ex + w / 2, ey + w / 2], fill=MARK)

    # Kronometre başlığı: halkanın tepesinde sap + düğme.
    top = cy - r  # halkanın dış kenarı (PIL yayı kalınlığı içe doğru çizer)
    d.rounded_rectangle([cx - 24 * k, top - 62 * k, cx + 24 * k, top + 30 * k], radius=10 * k, fill=MARK)
    d.rounded_rectangle([cx - 78 * k, top - 112 * k, cx + 78 * k, top - 58 * k], radius=27 * k, fill=MARK)

    # Onay işareti = "V": kısa kol halkanın içinde, uzun kol açık çeyrekten dışarı uzanır.
    round_line(d, [(350 * k, 566 * k), (468 * k, 684 * k), (770 * k, 306 * k)], w, MARK)
    return img


def ios_icon(background):
    return artwork(S, background).resize((1024, 1024), Image.LANCZOS)


def mac_icon(background):
    """macOS: şeffaf kenarlı, yuvarlak köşeli kare; düz stil için gölgesiz."""
    inner = 824 * S // 1024
    mask = Image.new("L", (inner, inner), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, inner - 1, inner - 1], radius=int(inner * 0.225), fill=255)
    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    off = (S - inner) // 2
    canvas.paste(artwork(inner, background), (off, off), mask)
    return canvas.resize((1024, 1024), Image.LANCZOS)


def main(out, color="teal"):
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    background = COLORS[color]
    ios_icon(background).save(out / "icon-ios-1024.png")
    mac = mac_icon(background)
    for size in (16, 32, 64, 128, 256, 512, 1024):
        mac.resize((size, size), Image.LANCZOS).save(out / f"icon-mac-{size}.png")


if __name__ == "__main__":
    main(*sys.argv[1:3])
