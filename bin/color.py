import colorsys

r = 0x0c / 255
g = 0x24 / 255
b = 0x3c / 255

h, s, v = colorsys.rgb_to_hsv(r, g, b)
v *= .7  # reducing by .3
r, g, b = colorsys.hsv_to_rgb(h, s, v)

r = int(r * 255)
g = int(g * 255)
b = int(b * 255)

print('%02x%02x%02x' % (r, g, b))
