local box = require("pixelbox_lite").new(term.current())

-- blue vertical line
box.canvas[5][5] = colors.blue
box.canvas[6][5] = colors.blue
box.canvas[7][5] = colors.blue

-- disconnect on it
box.canvas[6][6] = colors.blue

-- yellow vertical line
box.canvas[5][7] = colors.yellow
box.canvas[6][7] = colors.yellow
box.canvas[7][7] = colors.yellow

-- display to terminal
box:render()