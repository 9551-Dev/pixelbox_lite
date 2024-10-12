local pixelbox = {initialized=false,shared_data={},internal={}}

pixelbox.url     = "https://pixels.devvie.cc"
pixelbox.license = [[MIT License

Copyright (c) 2024 9551Dev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local box_object = {}

local to_blit = {}
local t_cat   = table.concat

local function generate_lookups()
    for i = 0, 15 do
        to_blit[2^i] = ("%x"):format(i)
    end
end

pixelbox.internal.to_blit_lookup   = to_blit
pixelbox.internal.generate_lookups = generate_lookups

function pixelbox.make_canvas_scanline(y_coord)
    return setmetatable({},{__newindex=function(self,key,value)
        if type(key) == "number" and key%1 ~= 0 then
            error(("Tried to write a float pixel. x:%s y:%s"):format(key,y_coord),2)
        else rawset(self,key,value) end
    end})
end

function pixelbox.make_canvas(source_table)
    local dummy_OOB = pixelbox.make_canvas_scanline("NONE")
    local dummy_mt  = getmetatable(dummy_OOB)

    function dummy_mt.tostring() return "pixelbox_dummy_oob" end

    return setmetatable(source_table or {},{__index=function(_,key)
        if type(key) == "number" and key%1 ~= 0 then
            error(("Tried to write float scanline. y:%s"):format(key),2)
        end

        return dummy_OOB
    end})
end

function pixelbox.setup_canvas(box,canvas_blank,color,keep_content)
    for y=1,box.height do

        local scanline
        if not rawget(canvas_blank,y) then
            scanline = pixelbox.make_canvas_scanline(y)

            rawset(canvas_blank,y,scanline)
        else
            scanline = canvas_blank[y]
        end

        for x=1,box.width do
            if not (scanline[x] and keep_content) then
                scanline[x] = color
            end
        end
    end

    return canvas_blank
end

function pixelbox.restore(box,color,keep_existing,keep_content)
    if not keep_existing then
        local new_canvas = pixelbox.setup_canvas(box,pixelbox.make_canvas(),color)

        box.canvas = new_canvas
        box.CANVAS = new_canvas
    else
        pixelbox.setup_canvas(box,box.canvas,color,keep_content)
    end
end

local string_rep = string.rep
function box_object:render()
    local term = self.term
    local blit_line,set_cursor = term.blit,term.setCursorPos

    local term_height = self.term_height

    local canv = self.canvas

    local fg_line_1,bg_line_1 = {},{}
    local fg_line_2,bg_line_2 = {},{}

    local x_offset,y_offset = self.x_offset,self.y_offset
    local width,height      = self.width,   self.height

    local even_char_line = string_rep("\131",width)
    local odd_char_line  = string_rep("\143",width)

    local sy = 0
    for y=1,height,3 do
        sy = sy + 2
        local layer_1 = canv[y]
        local layer_2 = canv[y+1]
        local layer_3 = canv[y+2]

        local n = 1
        for x=1,width do
            local color1 = layer_1[x]
            local color2 = layer_2[x]
            local color3 = layer_3[x]

            fg_line_1  [n] = to_blit[color1]
            bg_line_1  [n] = to_blit[color2]
            fg_line_2  [n] = to_blit[color2]
            bg_line_2  [n] = to_blit[color3 or color2]

            n = n + 1
        end

        set_cursor(1+x_offset,y_offset+sy-1)
        blit_line(odd_char_line,
            t_cat(fg_line_1,""),
            t_cat(bg_line_1,"")
        )

        if sy <= term_height then
            set_cursor(1+x_offset,y_offset+sy)
            blit_line(even_char_line,
                t_cat(fg_line_2,""),
                t_cat(bg_line_2,"")
            )
        end
    end
end

function box_object:clear(color)
    pixelbox.restore(self,to_blit[color or ""] and color or self.background,true,false)
end

function box_object:set_pixel(x,y,color)
    self.canvas[y][x] = color
end

function box_object:set_canvas(canvas)
    self.canvas = canvas
    self.CANVAS = canvas
end

function box_object:resize(w,h,color)
    self.term_width  = math.floor(w+0.5)
    self.term_height = math.floor(h+0.5)
    self.width       = math.floor(w+0.5)
    self.height      = math.floor(h*(3/2)+0.5)

    pixelbox.restore(self,color or self.background,true,true)
end

function pixelbox.module_error(module,str,level,supress_error)
    level = level or 1

    if module.__contact and not supress_error then
        local _,err_msg = pcall(error,str,level+2)
        printError(err_msg)
        error((module.__report_msg or "\nReport module issue at:\n-> __contact"):gsub("[%w_]+",module),0)
    elseif not supress_error then
        error(str,level+1)
    end
end

function box_object:load_module(modules)
    for k,module in ipairs(modules or {}) do
        local module_data = {
            __author     = module.author,
            __name       = module.name,
            __contact    = module.contact,
            __report_msg = module.report_msg
        }

        local module_fields,magic_methods = module.init(self,module_data,pixelbox,pixelbox.shared_data,pixelbox.initialized,modules)

        magic_methods    = magic_methods or {}
        module_data.__fn = module_fields


        if self.modules[module.id] and not modules.force then
            pixelbox.module_error(module_data,("Module ID conflict: %q"):format(module.id),2,modules.supress)
        else
            self.modules[module.id] = module_data
            if magic_methods.verified_load then
                magic_methods.verified_load()
            end
        end

        for fn_name in pairs(module_fields) do
            if self.modules.module_functions[fn_name] and not modules.force then
                pixelbox.module_error(module_data,("Module %q tried to register already existing element: %q"):format(module.id,fn_name),2,modules.supress)
            else
                self.modules.module_functions[fn_name] = {
                    id   = module.id,
                    name = fn_name
                }
            end
        end
    end
end

function pixelbox.new(terminal,bg,modules)
    local box = {
        modules = {module_functions={}}
    }

    box.background = bg or terminal.getBackgroundColor()

    local w,h = terminal.getSize()
    box.term  = terminal

    setmetatable(box,{__index = function(_,key)
        local module_fn = rawget(box.modules.module_functions,key)
        if module_fn then
            return box.modules[module_fn.id].__fn[module_fn.name]
        end

        return rawget(box_object,key)
    end})

    box.__bixelbox_lite = true

    box.term_width  = w
    box.term_height = h
    box.width       = w
    box.height      = math.ceil(h * (3/2))

    box.x_offset = 0
    box.y_offset = 0

    pixelbox.restore(box,box.background)

    if type(modules) == "table" then
        box:load_module(modules)
    end

    if not pixelbox.initialized then
        generate_lookups()

        pixelbox.initialized = true
    end

    return box
end

return pixelbox