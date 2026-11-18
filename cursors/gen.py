"""✦ Lost Galaxy cursor pack generator — pixel art on a 16px grid, exported 2x/3x/4x (32/48/64px)."""
import math, os, struct
from PIL import Image, ImageDraw

OUT = os.path.join(os.path.dirname(__file__), "Lost Galaxy")
os.makedirs(OUT, exist_ok=True)
G = 16
SCALES = (2, 3, 4)

def hx(h, a=255): return (int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16), a)
COL = {
    "K": hx("#11111b"), "W": hx("#ffffff"), "w": hx("#f5e0dc"), "P": hx("#f5c2e7"),
    "M": hx("#cba6f7"), "D": hx("#9d7cf0"), "L": hx("#b4befe"), "y": hx("#f9e2af"),
    "s": hx("#89dceb"), "R": hx("#f38ba8"), "g": hx("#585b70"), "d": hx("#11111b", 225),
}
OUTLINE = hx("#11111b")
STOPS = [(0.0, "#f5e0dc"), (0.35, "#f5c2e7"), (0.7, "#cba6f7"), (1.0, "#a58af0")]

def grad(y):
    t = y / (G - 1)
    for (t0, c0), (t1, c1) in zip(STOPS, STOPS[1:]):
        if t <= t1:
            f = (t - t0) / (t1 - t0); a, b = hx(c0), hx(c1)
            return tuple(round(a[i] + (b[i] - a[i]) * f) for i in range(3)) + (255,)
    return hx(STOPS[-1][1])

def blank(): return [["."] * G for _ in range(G)]
def from_rows(rows):
    g = blank()
    for y, r in enumerate(rows):
        for x, ch in enumerate(r[:G]):
            g[y][x] = ch
    return g
def put(g, pts, ch):
    for x, y in pts:
        if 0 <= x < G and 0 <= y < G: g[y][x] = ch
    return g

def render(g, outline=True):
    """grid -> 16x16 RGBA. '#' = gradient fill, letters = palette, auto 1px dark outline."""
    img = Image.new("RGBA", (G, G), (0, 0, 0, 0)); px = img.load()
    filled = {(x, y) for y in range(G) for x in range(G) if g[y][x] != "."}
    if outline:
        for x, y in filled:
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < G and 0 <= ny < G and (nx, ny) not in filled:
                        px[nx, ny] = OUTLINE
    for x, y in filled:
        ch = g[y][x]
        px[x, y] = grad(y) if ch == "#" else COL[ch]
    return img

# ─── shapes ────────────────────────────────────────────────────────
ARROW = from_rows([
    "................",
    ".#..............",
    ".##.............",
    ".#w#............",
    ".#w##...........",
    ".#w###..........",
    ".#w####.........",
    ".#w#####........",
    ".#w######.......",
    ".#w#######......",
    ".#w####.........",
    ".#w#.##.........",
    ".##..##.........",
    ".#....##........",
    "......##........",
    "................",
])
SMALL_ARROW = [
    "................",
    ".#..............",
    ".##.............",
    ".#w#............",
    ".#w##...........",
    ".#w###..........",
    ".#w####.........",
    ".#w##...........",
    ".##.##..........",
    ".#...##.........",
    ".....##.........",
]
def small_arrow(): return from_rows(SMALL_ARROW + ["." * 16] * 5)

HAND = from_rows([
    "................",
    ".....##.........",
    ".....#w.........",
    ".....#w.........",
    ".....#w.........",
    ".....#w.##.##...",
    ".....#w.##.##.#.",
    ".##..#w.##.##.#.",
    ".###.#w.##.##.#.",
    "..#############.",
    "..#############.",
    "...###########..",
    "...###########..",
    "....#########...",
    "....#########...",
    "................",
])
IBEAM = from_rows(["................", "....#####......."] + ["......#........."] * 12 + ["....#####.......", "................"])

def cross():
    g = blank()
    put(g, [(x, 7) for x in list(range(1, 6)) + list(range(9, 14))], "#")
    put(g, [(7, y) for y in list(range(1, 6)) + list(range(9, 14))], "#")
    return put(g, [(7, 7)], "y")

def unavailable():
    g = blank()
    for y in range(G):
        for x in range(G):
            d = math.hypot(x - 7, y - 7)
            if 4.6 <= d <= 6.4 or (d < 4.6 and x - y in (0, 1)):
                g[y][x] = "R"
    return g

NS_ROWS = [
    "................",
    ".......#........",
    "......###.......",
    ".....#####......",
    "....#######.....",
    ".......#........",
    ".......#........",
    ".......#........",
    ".......#........",
    ".......#........",
    ".......#........",
    "....#######.....",
    ".....#####......",
    "......###.......",
    ".......#........",
    "................",
]
def size_ns(): return from_rows(NS_ROWS)
def size_we():
    g = size_ns(); return [[g[x][y] for x in range(G)] for y in range(G)]
def size_nwse():
    g = blank()
    pts = [(i, i) for i in range(3, 13)]
    pts += [(x, y) for x in range(1, 6) for y in range(1, 6) if x + y <= 6]
    pts += [(15 - x, 15 - y) for x in range(1, 6) for y in range(1, 6) if x + y <= 6]
    return put(g, pts, "#")
def size_nesw():
    g = size_nwse(); return [list(reversed(r)) for r in g]
def size_all():
    return from_rows([
        "................",
        ".......#........",
        "......###.......",
        ".....#####......",
        ".......#........",
        "...#...#...#....",
        "..##...#...##...",
        ".#############..",
        "..##...#...##...",
        "...#...#...#....",
        ".......#........",
        ".....#####......",
        "......###.......",
        ".......#........",
        "................",
        "................",
    ])
def up_arrow(): return from_rows(NS_ROWS[:11] + ["." * 16] * 5)

def help_():
    g = small_arrow()
    return put(g, [(11, 8), (12, 8), (13, 8), (10, 9), (14, 9), (13, 10), (12, 11), (12, 12), (12, 14)], "s")
def person():
    g = small_arrow()
    put(g, [(11, 9), (12, 9), (11, 10), (12, 10)], "s")
    return put(g, [(x, y) for x in range(10, 14) for y in range(12, 15)], "s")
def pin():
    g = blank()
    for y in range(G):
        for x in range(G):
            if math.hypot(x - 7, y - 5) <= 3.6: g[y][x] = "#"
    put(g, [(6, 9), (7, 9), (8, 9), (6, 10), (7, 10), (8, 10), (7, 11), (7, 12), (7, 13)], "#")
    return put(g, [(7, 5)], "K")
def pen():
    g = blank()
    for i in range(3, 12):
        put(g, [(i, 15 - i), (i + 1, 15 - i)], "#")
    put(g, [(2, 13), (3, 13), (3, 12)], "w")           # tip
    put(g, [(11, 4), (12, 4), (12, 3), (13, 3)], "P")  # eraser
    return g

# ─── animated pieces ───────────────────────────────────────────────
def sparkle(g, cx, cy, size):
    if size >= 1: put(g, [(cx, cy)], "y")
    if size >= 2: put(g, [(cx - 1, cy), (cx + 1, cy), (cx, cy - 1), (cx, cy + 1)], "s")
    if size >= 3: put(g, [(cx, cy - 2), (cx, cy + 2), (cx - 2, cy), (cx + 2, cy)], "L")
    return g

def galaxy(g, cx, cy, r_disc, r_ring, n, head):
    """dark disc + orbiting comet. head = index of the bright point."""
    for y in range(G):
        for x in range(G):
            d = math.hypot(x - cx, y - cy)
            if d <= r_disc: g[y][x] = "d"
            if r_disc - 0.9 < d <= r_disc: g[y][x] = "D"
    tail = ["W", "y", "P", "M", "D", "L"]
    for k in range(n):
        a = 2 * math.pi * k / n - math.pi / 2
        x, y = round(cx + r_ring * math.cos(a)), round(cy + r_ring * math.sin(a))
        age = (head - k) % n
        g[y][x] = tail[age] if age < len(tail) else "g"
    put(g, [(round(cx), round(cy))], "y")
    return g

# ─── writers ───────────────────────────────────────────────────────
def dib(img):
    w, h = img.size; px = img.load()
    hdr = struct.pack("<IiiHHIIiiII", 40, w, h * 2, 1, 32, 0, 0, 0, 0, 0, 0)
    xor = bytearray()
    for y in range(h - 1, -1, -1):
        for x in range(w):
            r, g, b, a = px[x, y]; xor += bytes((b, g, r, a))
    stride = ((w + 31) // 32) * 4; andm = bytearray()
    for y in range(h - 1, -1, -1):
        row = bytearray(stride)
        for x in range(w):
            if px[x, y][3] == 0: row[x // 8] |= 0x80 >> (x % 8)
        andm += row
    return hdr + bytes(xor) + bytes(andm)

def cur_bytes(img16, hot):
    imgs = [(img16.resize((G * s, G * s), Image.NEAREST), s) for s in SCALES]
    datas = [dib(i) for i, _ in imgs]
    out = struct.pack("<HHH", 0, 2, len(imgs)); off = 6 + 16 * len(imgs)
    for (i, s), d in zip(imgs, datas):
        w = i.size[0]
        out += struct.pack("<BBBBHHII", w % 256, w % 256, 0, 0, hot[0] * s, hot[1] * s, len(d), off); off += len(d)
    return out + b"".join(datas)

def chunk(tag, data):
    return tag + struct.pack("<I", len(data)) + data + (b"\0" if len(data) % 2 else b"")

def ani_bytes(frames16, hot, rates):
    anih = struct.pack("<9I", 36, len(frames16), len(frames16), 0, 0, 0, 0, rates[0], 1)
    rate = struct.pack(f"<{len(rates)}I", *rates)
    fram = b"fram" + b"".join(chunk(b"icon", cur_bytes(f, hot)) for f in frames16)
    body = b"ACON" + chunk(b"anih", anih) + chunk(b"rate", rate) + chunk(b"LIST", fram)
    return b"RIFF" + struct.pack("<I", len(body)) + body

def save_cur(name, g, hot):
    open(os.path.join(OUT, name), "wb").write(cur_bytes(render(g), hot)); return render(g)
def save_ani(name, grids, hot, rates):
    imgs = [render(g) for g in grids]
    open(os.path.join(OUT, name), "wb").write(ani_bytes(imgs, hot, rates)); return imgs

# ─── build ─────────────────────────────────────────────────────────
P = {}
P["arrow.cur"]      = save_cur("arrow.cur", ARROW, (1, 1))
sizes = [0, 0, 0, 0, 1, 2, 3, 2, 1, 0]
P["arrow.ani"]      = save_ani("arrow.ani", [sparkle([r[:] for r in ARROW], 12, 12, s) for s in sizes], (1, 1), [40, 20, 20, 20, 6, 6, 8, 6, 6, 20])
P["busy.ani"]       = save_ani("busy.ani", [galaxy(blank(), 7.5, 7.5, 7.0, 5.0, 12, h) for h in range(12)], (7, 7), [5] * 12)
P["working.ani"]    = save_ani("working.ani", [galaxy(small_arrow(), 11.5, 11.5, 3.6, 2.4, 8, h) for h in range(8)], (1, 1), [6] * 8)
P["link.cur"]       = save_cur("link.cur", HAND, (5, 1))
P["text.cur"]       = save_cur("text.cur", IBEAM, (6, 8))
P["cross.cur"]      = save_cur("cross.cur", cross(), (7, 7))
P["unavailable.cur"]= save_cur("unavailable.cur", unavailable(), (7, 7))
P["vert.cur"]       = save_cur("vert.cur", size_ns(), (7, 7))
P["horz.cur"]       = save_cur("horz.cur", size_we(), (7, 7))
P["dgn1.cur"]       = save_cur("dgn1.cur", size_nwse(), (7, 7))
P["dgn2.cur"]       = save_cur("dgn2.cur", size_nesw(), (7, 7))
P["move.cur"]       = save_cur("move.cur", size_all(), (7, 7))
P["alternate.cur"]  = save_cur("alternate.cur", up_arrow(), (7, 1))
P["help.cur"]       = save_cur("help.cur", help_(), (1, 1))
P["person.cur"]     = save_cur("person.cur", person(), (1, 1))
P["pin.cur"]        = save_cur("pin.cur", pin(), (7, 13))
P["handwriting.cur"]= save_cur("handwriting.cur", pen(), (2, 13))

# ─── preview sheet ─────────────────────────────────────────────────
order = ["arrow.cur", "arrow.ani", "help.cur", "working.ani", "busy.ani", "cross.cur", "text.cur", "handwriting.cur", "unavailable.cur",
         "vert.cur", "horz.cur", "dgn1.cur", "dgn2.cur", "move.cur", "alternate.cur", "link.cur", "pin.cur", "person.cur"]
S, cell = 4, 16 * 4 + 24
sheet = Image.new("RGBA", (cell * 9, cell * 4), hx("#1e1e2e")); d = ImageDraw.Draw(sheet)
d.rectangle([0, cell * 2, cell * 9, cell * 4], fill=hx("#eff1f5"))
for i, n in enumerate(order):
    v = P[n]; frames = v if isinstance(v, list) else [v]
    for band in (0, 2):
        x, y = (i % 9) * cell + 12, (i // 9 + band) * cell + 12
        fr = frames[min(len(frames) - 1, 6)] if n == "arrow.ani" else frames[0]
        sheet.alpha_composite(fr.resize((64, 64), Image.NEAREST), (x, y))
sheet.save(os.path.join(os.path.dirname(__file__), "preview.png"))
# animated previews
for n in ("busy.ani", "working.ani", "arrow.ani"):
    fr = [f.resize((128, 128), Image.NEAREST) for f in P[n]]
    bg = [Image.alpha_composite(Image.new("RGBA", f.size, hx("#313244")), f) for f in fr]
    bg[0].save(os.path.join(os.path.dirname(__file__), n.replace(".ani", "-preview.gif")), save_all=True,
               append_images=bg[1:], duration=[83] * len(bg) if n != "arrow.ani" else [660, 330, 330, 330, 100, 100, 130, 100, 100, 330], loop=0, disposal=2)
print("ok", sorted(os.listdir(OUT)))
