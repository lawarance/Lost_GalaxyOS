"""✦ Lost Galaxy — chubby pixel astronaut pfp, 2 poses (32x32 grid -> 512/448 px).
   star : big helmet, holding a glowing star
   arms : smaller helmet, long arms down by his sides
   chest panel spells SDH"""
import math, random
from PIL import Image

N = 32
def hx(h): return (int(h[1:3], 16), int(h[3:5], 16), int(h[5:7], 16), 255)
C = {k: hx(v) for k, v in dict(
    void="#07070c", crust="#11111b", s1="#45475a", s0="#313244", white="#ffffff", rose="#f5e0dc",
    pink="#f5c2e7", mauve="#cba6f7", deep="#7f5fd0", night="#2a2050", lav="#b4befe", sub="#bac2de",
    ov="#9399b2", ov0="#6c7086", yel="#f9e2af", gold="#ffcc4d", sky="#89dceb", red="#f38ba8").items()}
def mix(a, b, t): t = max(0, min(1, t)); return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3)) + (255,)
def ell(cx, cy, rx, ry, x, y): return ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2

FONT = {  # 3x5
    "S": ["###", "#..", "###", "..#", "###"],
    "D": ["##.", "#.#", "#.#", "#.#", "##."],
    "H": ["#.#", "#.#", "###", "#.#", "#.#"],
}

def make(pose):
    img = Image.new("RGBA", (N, N)); px = img.load()
    # background
    for y in range(N):
        for x in range(N): px[x, y] = mix(C["void"], C["crust"], y / (N - 1))
    random.seed(3)
    for _ in range(10):
        x, y = random.randrange(N), random.randrange(N); px[x, y] = random.choice([C["s1"], C["ov0"]])
    def star(x, y, core, arm):
        px[x, y] = core
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)): px[x + dx, y + dy] = arm
    star(3, 4, C["lav"], C["deep"]); star(28, 6, C["yel"], C["s1"]); px[2, 17] = C["pink"]; px[29, 15] = C["sky"]

    fill = {}
    def F(x, y, c):
        x, y = int(x), int(y)
        if 0 <= x < N and 0 <= y < N: fill[(x, y)] = c
    def suit(x, cx, rx):
        t = (x + 0.5 - (cx - rx)) / (2 * rx)
        return C["white"] if t < 0.3 else C["rose"] if t < 0.62 else C["sub"] if t < 0.85 else C["ov"]
    def limb(path, r, color, edge):
        """thick limb along a path: grey edge ring then color, so it reads in front of the body"""
        pts = []
        for (x0, y0), (x1, y1) in zip(path, path[1:]):
            n = int(max(abs(x1 - x0), abs(y1 - y0)) * 3) + 1
            pts += [(x0 + (x1 - x0) * i / n, y0 + (y1 - y0) * i / n) for i in range(n + 1)]
        for layer, rad, col in ((0, r + 1, edge), (1, r, color)):
            for y in range(N):
                for x in range(N):
                    if any(math.hypot(x + 0.5 - px_, y + 0.5 - py_) <= rad for px_, py_ in pts): F(x, y, col)

    if pose == "star":
        H = (16, 10.5, 11, 9.2); V = (16, 11, 8, 5.2); BODY = (16, 29, 9.5, 9.5); NECK = 19; PANEL = (21, 10)
    else:
        H = (16, 9.2, 9.2, 8); V = (16, 9.6, 6.6, 4.4); BODY = (16, 29, 8.2, 11); NECK = 17; PANEL = (21, 10)

    # body
    bx, by, brx, bry = BODY
    for y in range(N):
        for x in range(N):
            if ell(bx, by, brx, bry, x, y) <= 1: F(x, y, suit(x, bx, brx))
    for x in range(N):                                                     # belt
        if ell(bx, by, brx, bry, x, 29) <= 1: F(x, 29, C["mauve"])
    # neck ring
    for x in range(9, 24): F(x, NECK, C["lav"]); F(x, NECK + 1, C["mauve"])
    # arms
    if pose == "star":
        limb([(7, 24), (8.5, 28), (11.5, 28.5)], 1.6, C["rose"], C["ov"])
        limb([(25, 24), (23.5, 28), (20.5, 28.5)], 1.6, C["sub"], C["ov"])
        for x, y in [(11, 28), (12, 28), (11, 29), (12, 29)]: F(x, y, C["mauve"])   # gloves
        for x, y in [(20, 28), (21, 28), (20, 29), (21, 29)]: F(x, y, C["deep"])
    # big glowing star (drawn last-ish so it sits in front)
    if pose == "star":
        STAR = ["...#...", "..###..", "#######", ".#####.", "..###..", ".##.##.", ".#...#."]
        spts = {(13 + rx, 25 + ry) for ry, row in enumerate(STAR) for rx, b in enumerate(row) if b == "#"}
        for x, y in spts:                                   # dark outline so it pops off the suit
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    if (x + dx, y + dy) not in spts: F(x + dx, y + dy, C["void"])
        for x, y in [(11, 28), (11, 29)]: F(x, y, C["mauve"])            # gloves gripping the tips
        for x, y in [(21, 28), (21, 29)]: F(x, y, C["deep"])
        for x, y in spts: F(x, y, C["gold"])
        for x, y in [(16, 27), (16, 28), (15, 27)]: F(x, y, C["white"])
        for x, y in [(17, 28), (16, 29), (15, 28)]: F(x, y, C["yel"])
    else:
        limb([(7.8, 20), (6.5, 25), (6, 28.5)], 1.5, C["rose"], C["ov"])
        limb([(24.2, 20), (25.5, 25), (26, 28.5)], 1.5, C["sub"], C["ov"])
        for x, y in [(5, 29), (6, 29), (5, 30), (6, 30)]: F(x, y, C["mauve"])
        for x, y in [(25, 29), (26, 29), (25, 30), (26, 30)]: F(x, y, C["deep"])

    # chest panel: small with lights (star pose) / SDH (arms pose)
    if pose == "star":
        for y in range(21, 25):
            for x in range(13, 20): F(x, y, C["s0"])
        F(14, 22, C["sky"]); F(16, 22, C["pink"]); F(18, 22, C["yel"])
        for x in range(14, 19): F(x, 23, C["deep"])
    py0, px0 = PANEL
    if pose != "star":
      for y in range(py0, py0 + 7):
        for x in range(px0, px0 + 13): F(x, y, C["s0"])
      for i, (ch, col) in enumerate(zip("SDH", (C["pink"], C["mauve"], C["sky"]))):
          for ry, row in enumerate(FONT[ch]):
            for rx, b in enumerate(row):
                if b == "#": F(px0 + 1 + i * 4 + rx, py0 + 1 + ry, col)

    # helmet
    hx_, hy, hrx, hry = H
    for y in range(N):
        for x in range(N):
            if ell(hx_, hy, hrx, hry, x, y) <= 1:
                t = ((x - hx_) / hrx + (y - hy) / hry) / 2 + 0.5
                F(x, y, C["white"] if t < 0.32 else C["rose"] if t < 0.6 else C["sub"] if t < 0.8 else C["ov"])
    el, er = int(hx_ - hrx - 0.5), int(hx_ + hrx - 0.5)
    for y in range(int(hy) - 2, int(hy) + 3): F(el, y, C["mauve"]); F(er, y, C["deep"])   # ear knobs
    ax, ay = int(hx_ + hrx * 0.62), int(hy - hry * 0.72)                                 # antenna
    for i in range(1, 3): F(ax + i, ay - i, C["ov"])
    F(ax + 3, ay - 3, C["pink"]); F(ax + 4, ay - 3, C["pink"]); F(ax + 3, ay - 4, C["pink"]); F(ax + 4, ay - 4, C["red"])

    # visor + rim
    vx, vy, vrx, vry = V
    for y in range(N):
        for x in range(N):
            e = ell(vx, vy, vrx + 1, vry + 1, x, y); e0 = ell(vx, vy, vrx, vry, x, y)
            if e0 <= 1: F(x, y, mix(C["mauve"], C["night"], (y - (vy - vry)) / (2 * vry) * 1.2))
            elif e <= 1: F(x, y, C["deep"])
    for dx, dy in [(-5, -3), (-4, -3), (-3, -4), (-6, -2)]: F(vx + dx, vy + dy, C["white"])   # shine
    F(vx - 2, vy - 4, C["pink"])
    for dx, dy, c in [(4, 1.5, C["yel"]), (5, 1.5, C["pink"]), (3, 1.5, C["mauve"]), (4, 0.5, C["lav"]), (4, 2.5, C["sky"])]:
        F(vx + dx, vy + dy, c)                                                                  # galaxy reflection

    # outline + paint
    for (x, y) in list(fill):
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                p = (x + dx, y + dy)
                if 0 <= p[0] < N and 0 <= p[1] < N and p not in fill: px[p] = C["void"]
    for (x, y), c in fill.items(): px[x, y] = c
    for size in (512, 448):
        img.resize((size, size), Image.NEAREST).save(f"/home/claude/cursors/astronaut-{pose}-{size}.png")

for pose in ("star", "arms"): make(pose)
print("ok")
