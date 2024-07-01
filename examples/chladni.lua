local box = require("pixelbox_lite").new(term.current())

local n,m,scale  = 0.9,7.8,30
local full_color = 15/4

for i=0,15 do local c = i/15 term.setPaletteColor(2^i,c,c,c) end

for y=1,box.height do
    for x=1,box.width do
        box.canvas[y][x] = 2^math.floor(((
            math.sin(n*math.pi*x/scale) *
            math.sin(m*math.pi*y/scale) +
            math.sin(m*math.pi*x/scale) *
            math.sin(n*math.pi*y/scale)
        )*full_color)%15)
    end
end

box:render()

os.pullEvent("char")
for i=0,15 do term.setPaletteColor(2^i,term.nativePaletteColor(2^i)) end