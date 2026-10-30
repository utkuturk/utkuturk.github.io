# Regenerates the three SVG figures for this post: python3 make-figures.py
import math
import random
from pathlib import Path

HERE = Path(__file__).parent
FONT = 'font-family="Inter, system-ui, -apple-system, Helvetica, Arial, sans-serif"'
MONO = 'font-family="Fira Code, ui-monospace, Menlo, monospace"'
INK, INK2, RULE = "#0b0b0b", "#52514e", "#d9d8d4"
BLUE, ORANGE = "#2a78d6", "#eb6834"
# 8 charge levels, erased (least charge) to most charge
LEVELS = ["#eef4fc", "#cde2fb", "#9ec5f4", "#6da7ec", "#3987e5", "#256abf", "#184f95", "#0d366b"]


def svg(w, h, body, title):
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" width="{w}" height="{h}" '
            f'role="img" aria-label="{title}" {FONT}>\n{body}\n</svg>\n')


def text(x, y, s, size=13, fill=INK, anchor="start", weight=400, extra=""):
    return (f'<text x="{x}" y="{y}" font-size="{size}" fill="{fill}" text-anchor="{anchor}" '
            f'font-weight="{weight}" {extra}>{s}</text>')


def bits_and_cells():
    # the SSD is never blank: before = leftovers (old files, factory tests), after = the games written over them
    rng = random.Random(29)
    before = [rng.getrandbits(1) for _ in range(96)]
    after = [rng.getrandbits(1) for _ in range(96)]
    out = []
    top, bottom = 52, 240
    out.append(text(0, top + 30, "the 1s and 0s", 14, weight=600))
    out.append(text(0, top + 48, "what is saved", 12, INK2))
    out.append(text(0, bottom + 30, "the electric charge", 14, weight=600))
    out.append(text(0, bottom + 48, "what the drive holds", 12, INK2))
    cols = [(160, "before", "leftovers of old files and factory tests", before),
            (470, "after", "the games written over them", after)]
    all_levels = []
    for x0, title, sub, data in cols:
        out.append(text(x0, 18, title, 15, weight=600))
        out.append(text(x0, 36, sub, 12, INK2))
        codes = ["".join(map(str, data[i:i + 3])) for i in range(0, 96, 3)]
        # illustrative mapping from 3 bits to 8 charge levels, not a real drive's Gray code
        levels = [7 - int(c, 2) for c in codes]
        all_levels.append(levels)
        for i, (code, lvl) in enumerate(zip(codes, levels)):
            x, y = x0 + (i % 8) * 31, (i // 8) * 31
            out.append(f'<rect x="{x}" y="{top + y}" width="29" height="29" rx="4" fill="#fff" stroke="{RULE}"/>')
            out.append(text(x + 14.5, top + y + 19, code, 9, INK, "middle", extra=MONO))
            out.append(f'<rect x="{x}" y="{bottom + y}" width="29" height="29" rx="4" fill="{LEVELS[lvl]}" '
                       f'stroke="{RULE if lvl == 0 else "none"}"/>')
            out.append(text(x + 14.5, bottom + y + 19, code, 9, "#fff" if lvl >= 4 else INK, "middle", extra=MONO))
        ones = sum(data)
        out.append(text(x0, top + 144, f"{ones} ones, {96 - ones} zeros ({round(100 * ones / 96)}% 1s)", 12, INK2))
        out.append(text(x0, bottom + 144, f"average charge level: {sum(levels) / len(levels):.1f}", 12, INK, weight=600))
    changed = sum(a != b for a, b in zip(*all_levels))
    out.append(text(470, bottom + 162, f"{changed} of 32 cells changed charge", 12, INK2))
    out.append(text(160, bottom + 192, "less charge", 11, INK2))
    for i, c in enumerate(LEVELS):
        out.append(f'<rect x="{228 + i * 22}" y="{bottom + 182}" width="20" height="12" rx="2" fill="{c}" '
                   f'stroke="{RULE if i == 0 else "none"}"/>')
    out.append(text(228 + 8 * 22 + 6, bottom + 192, "more charge", 11, INK2))
    return svg(770, bottom + 202, "\n".join(out), "An SSD before and after: about half 1s both times, but the charge in the cells changes")


def full(v, unit):
    # one significant digit, written out with all its zeros (no scientific notation)
    if v >= 1:
        return f"{v:,.0f} {unit}"
    d = -math.floor(math.log10(v))
    return f"{round(v, d):.{d}f} {unit}"


def sig1(x):
    e = math.floor(math.log10(x))
    return int(round(x / 10 ** e) * 10 ** e)


def scale_plot():
    rows = [("the whole laptop", 1550),
            ("battery, charged vs. empty", 2.8e-9),
            ("700 GB, empty vs. full (extreme case)", 1e-16),
            ("a Kindle, full vs. empty (Kubiatowicz)", 1e-18)]
    x0, x1 = 300, 760
    px_per_g = (x1 - x0) / rows[0][1]  # linear: the laptop fills the bar
    out = []
    for i, (label, v) in enumerate(rows):
        y = 24 + i * 58
        out.append(text(0, y, label, 13, weight=600))
        out.append(text(0, y + 20, full(v, "g"), 12, INK2, extra=MONO))
        out.append(f'<line x1="{x0}" y1="{y - 18}" x2="{x0}" y2="{y + 26}" stroke="{RULE}"/>')
        w = v * px_per_g
        if w >= 1:
            out.append(f'<rect x="{x0}" y="{y - 12}" width="{w:.1f}" height="26" rx="4" fill="{BLUE}"/>')
        else:
            out.append(text(x0 + 10, y, "too small to draw", 12, INK2))
            out.append(text(x0 + 10, y + 20, f"width on this chart: {full(w, 'px')}", 12, INK2, extra=MONO))
    # how wide the small bars get if the laptop's bar were stretched to real distances
    atom = 1.06e-10  # hydrogen atom diameter, m
    y = 24 + len(rows) * 58
    out.append(text(0, y, "if the laptop's bar were as wide as…", 12, INK2))
    out.append(text(250, y, "the battery's bar would be", 12, INK2))
    out.append(text(480, y, "and the games' bar", 12, INK2))
    places = [("Turkey (≈ 1,600 km)", 1.6e6, "a bacterium"), ("the equator (≈ 40,000 km)", 4.0075e7, "a hair")]
    for j, (place, metres, note) in enumerate(places):
        yy = y + 24 + j * 22
        b, g = metres * rows[1][1] / rows[0][1], metres * rows[2][1] / rows[0][1]
        out.append(text(0, yy, place, 13, weight=600))
        out.append(text(250, yy, f"{full(b * 1000, 'mm')} ({note})", 13))
        out.append(text(480, yy, f"{full(g * 1000, 'mm')} (1/{sig1(atom / g):,} of an atom)", 13))
    y = yy
    return svg(770, y + 30, "\n".join(out), "Linear comparison: only the laptop is visible; the mass changes are too small to draw")


def grooves():
    # the record computer: every 1 is a groove cut out of the disk, every 0 is left alone
    rows = [("four spaces", " ", "00100000"), ("four tildes", "~", "01111110")]
    x0, slot, gap = 190, 13, 8
    out = []
    for r, (label, ch, byte) in enumerate(rows):
        y = 40 + r * 110
        cut = 4 * byte.count("1")
        out.append(text(0, y + 30, label, 15, weight=600))
        out.append(text(0, y + 50, f'"{ch * 4}" = {byte} × 4', 12, INK2, extra='xml:space="preserve"'))
        width = 4 * 8 * slot + 3 * gap
        out.append(f'<rect x="{x0}" y="{y + 18}" width="{width}" height="30" rx="3" fill="{LEVELS[2]}"/>')
        for c in range(4):
            for b, bit in enumerate(byte):
                x = x0 + c * (8 * slot + gap) + b * slot
                out.append(text(x + slot / 2, y + 10, bit, 12, INK if bit == "1" else INK2, "middle", extra=MONO))
                if bit == "1":
                    out.append(f'<rect x="{x + 2}" y="{y + 17}" width="{slot - 4}" height="16" rx="2" fill="#fff"/>')
        out.append(text(x0 + width + 16, y + 30, f"{cut} grooves cut", 13, INK, weight=600))
        out.append(text(x0 + width + 16, y + 48, "lighter" if r else "barely touched", 12, INK2))
    out.append(f'<rect x="0" y="246" width="20" height="12" rx="2" fill="{LEVELS[2]}"/>')
    out.append(text(28, 256, "disk material", 12, INK2))
    out.append(f'<rect x="130" y="246" width="12" height="12" rx="2" fill="#fff" stroke="{RULE}"/>')
    out.append(text(150, 256, "groove: material cut away for a 1", 12, INK2))
    return svg(770, 266, "\n".join(out), "Four spaces cut 4 grooves, four tildes cut 24 grooves")


def hdd():
    # the old hard disk: free space keeps the leftovers of deleted files, the games are written over them
    rng = random.Random(3)
    before = [rng.getrandbits(1) for _ in range(96)]
    after = [rng.getrandbits(1) for _ in range(96)]
    flipped = sum(a != b for a, b in zip(before, after))
    out = []
    top, bottom, pitch = 52, 200, 16
    out.append(text(0, top + 40, "the 1s and 0s", 14, weight=600))
    out.append(text(0, top + 58, "on the disk", 12, INK2))
    out.append(text(0, bottom + 40, "the magnetic regions", 14, weight=600))
    out.append(text(0, bottom + 58, "which way each one points", 12, INK2))
    cols = [(170, "before", "free space: leftovers of deleted files", before),
            (480, "after", "the games written over them", after)]
    for x0, title, sub, bits in cols:
        out.append(text(x0, 18, title, 15, weight=600))
        out.append(text(x0, 36, sub, 12, INK2))
        for i, b in enumerate(bits):
            x, y = x0 + (i % 16) * pitch, (i // 16) * pitch
            out.append(text(x + 7, top + y + 11, b, 11, INK if b else INK2, "middle", extra=MONO))
            # toy mapping: 1 points up, 0 points down (real drives encode bits in the changes between regions)
            out.append(f'<rect x="{x}" y="{bottom + y}" width="14" height="14" rx="2" fill="{BLUE if b else ORANGE}"/>')
            out.append(text(x + 7, bottom + y + 11, "↑" if b else "↓", 10, "#fff", "middle", 700))
        ones = sum(bits)
        out.append(text(x0, top + 6 * pitch + 18, f"{ones} ones, {96 - ones} zeros ({round(100 * ones / 96)}% 1s)", 12, INK2))
        out.append(text(x0, bottom + 6 * pitch + 18, f"{ones} up, {96 - ones} down", 12, INK, weight=600))
    out.append(text(480, bottom + 6 * pitch + 36, f"{flipped} of 96 regions flipped", 12, INK2))
    y = bottom + 6 * pitch + 68
    out.append(f'<rect x="170" y="{y - 11}" width="14" height="14" rx="2" fill="{BLUE}"/>')
    out.append(text(177, y, "↑", 10, "#fff", "middle", 700))
    out.append(text(190, y, "= 1", 12, INK2))
    out.append(f'<rect x="226" y="{y - 11}" width="14" height="14" rx="2" fill="{ORANGE}"/>')
    out.append(text(233, y, "↓", 10, "#fff", "middle", 700))
    out.append(text(246, y, "= 0", 12, INK2))
    out.append(text(290, y, "both directions cost the same energy", 12, INK2))
    return svg(770, y + 10, "\n".join(out), "An old hard disk before and after: about half 1s both times, the regions flip but the totals stay about the same")


def thumb():
    # listing thumbnail in the site's style: black strokes, grey fills; a level balance with 1 vs 0
    ink, grey = "#1a1a1a", "#c8c8c8"
    line = lambda x1, y1, x2, y2: (f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{ink}" '
                                   f'stroke-width="16" stroke-linecap="round"/>')
    pan = lambda cx: f'<path d="M {cx - 95} 432 H {cx + 95} L {cx + 65} 462 H {cx - 65} Z" fill="{grey}"/>'
    digit = lambda cx, d: (f'<text x="{cx}" y="418" font-size="260" font-weight="600" text-anchor="middle" fill="{ink}" '
                           f'font-family="Source Serif Pro, Source Serif 4, Georgia, serif">{d}</text>')
    body = [f'<rect width="800" height="800" fill="#fff"/>',
            line(250, 700, 550, 700), line(400, 700, 400, 540), line(150, 540, 650, 540),
            f'<circle cx="400" cy="540" r="20" fill="{ink}"/>',
            line(170, 540, 170, 462), line(630, 540, 630, 462),
            pan(170), pan(630), digit(170, 1), digit(630, 0)]
    return svg(800, 800, "\n".join(body), "A level balance scale with a 1 on one pan and a 0 on the other")


def thumb_card():
    # alternative thumbnail: Marr's "get out of jail free" card, voided, in front of jail bars (original design)
    ink, grey, bars, red = "#1a1a1a", "#9a9a9a", "#dedede", "#c8312b"
    serif = 'font-family="Georgia, Source Serif Pro, serif"'
    t = lambda y, s, size, extra="", fill=ink: (f'<text x="400" y="{y}" font-size="{size}" text-anchor="middle" fill="{fill}" '
                                      f'{serif} {extra}>{s}</text>')
    jail = [f'<rect x="{x}" y="40" width="22" height="720" rx="6" fill="{bars}"/>' for x in range(64, 800, 96)]
    jail += [f'<rect x="40" y="{y}" width="720" height="22" rx="6" fill="{bars}"/>' for y in (40, 738)]
    card = [f'<rect x="100" y="165" width="600" height="470" rx="26" fill="#fff" stroke="{ink}" stroke-width="12"/>',
            f'<rect x="120" y="185" width="560" height="430" rx="14" fill="none" stroke="{ink}" stroke-width="3"/>',
            t(240, "MARR · 1982", 28, 'letter-spacing="10"'),
            f'<line x1="180" y1="264" x2="620" y2="264" stroke="{ink}" stroke-width="3"/>',
            t(348, "GET OUT OF", 72, 'font-weight="700"'),
            t(428, "JAIL FREE", 72, 'font-weight="700"'),
            t(478, "USE WHEN", 22, 'font-weight="700" letter-spacing="6"'),
            t(513, "you do not want to face", 26, 'font-style="italic"'),
            t(546, "the consequences of your assumptions.", 26, 'font-style="italic"'),
            t(588, "excuses the holder from the other two levels", 19, fill=grey)]
    stamp = [f'<rect x="480" y="610" width="250" height="100" rx="10" fill="none" stroke="{red}" stroke-width="11"/>',
             f'<text x="605" y="689" font-size="80" font-weight="700" letter-spacing="8" text-anchor="middle" '
             f'fill="{red}" {serif}>VOID</text>']
    body = ([f'<rect width="800" height="800" fill="#fff"/>'] + jail +
            [f'<rect x="114" y="179" width="600" height="470" rx="26" fill="#c8c8c8" transform="rotate(-5 400 400)"/>',
             f'<g transform="rotate(-5 400 400)">' + "".join(card) + '</g>',
             f'<g transform="rotate(-14 605 660)" opacity="0.92">' + "".join(stamp) + '</g>'])
    return svg(800, 800, "\n".join(body), "Marr's get-out-of-jail-free card, voided, in front of jail bars")


for name, make in [("fig-bits.svg", bits_and_cells), ("fig-scale.svg", scale_plot), ("fig-grooves.svg", grooves), ("fig-hdd.svg", hdd), ("thumb-marr.svg", thumb), ("thumb-marr-card.svg", thumb_card)]:
    (HERE / name).write_text(make())
