-- matexture

local window = {
    width  = 0,
    height = 0,
    ratio  = {
        width  = 0,
        height = 0
    }
}

local image = {
    data     = nil,
    drawable = nil,
    scale    = 0,
    x        = 0,
    y        = 0,
    width    = 0,
    height   = 0,

    draw = function(self)
        love.graphics.setColor(1.0, 1.0, 1.0)

        love.graphics.push()
            love.graphics.scale(self.scale)
            love.graphics.draw(self.drawable, self.x, self.y)
        love.graphics.pop()
    end
}

local mouse = {
    last = {
        x = -1,
        y = -1
    }
}

local config = {
    modes     = {
        rgb            = {
            index = 0,
            text  = "RGB"
        },
        rgb_normalized = {
            index = 1,
            text  = "RGB (normalized)"
        },
        hsv            = {
            index = 2,
            text  = "HSV"
        },
        hsv_normalized = {
            index = 3,
            text  = "HSV (normalized)"
        },
        hex            = {
            index = 4,
            text  = "HEX"
        }
    },
    mode      = 0,
    decimals  = 14,
    font      = "source_code_pro_black.ttf",
    fontsize  = 30,
    clipboard = "",
    bits      = {
        r = 0,
        g = 0,
        b = 0,
        total = {
            r = 0,
            g = 0,
            b = 0
        }
    },
    background = {
        color = {
            r = 0.1,
            g = 0.11,
            b = 0.14
        }
    }
}

local style = {
    fg = 0,
    bg = 1,

    set_color = function(self, mode, active, r, g, b)
        if mode == self.fg then
            if active then
                love.graphics.setColor(0.0, 0.0, 0.0)
            else
                if r and g and b then
                    love.graphics.setColor(r, g, b)
                else
                    love.graphics.setColor(1.0, 1.0, 1.0)
                end
            end
        else
            if active then
                love.graphics.setColor(1.0, 1.0, 1.0)
            else
                love.graphics.setColor(0.0, 0.0, 0.0)
            end
        end
    end
}

local ui = {
    color = {
        x    = 0,
        y    = 0,
        z    = 0,
        text = {
            str   = "0, 0, 0",
            color = 1.0
        }
    },
    active = 0,
    height = 50,

    draw_bits = function(self, x, width)
        local i = 0
        local a = self.active == i

        style:set_color(style.bg, false)
        love.graphics.rectangle("fill", x, 0, width * 3, self.height)
        style:set_color(style.fg, false)
        love.graphics.printf("BITS", x, 0, width * 3, "center")

        style:set_color(style.bg, a)
        love.graphics.rectangle("fill", x, self.height, width, self.height)
        style:set_color(style.fg, a, 1.0, 0.0, 0.0)
        love.graphics.printf("R "..config.bits.r, x, self.height, width, "center")

        i = i + 1
        a = self.active == i

        style:set_color(style.bg, a)
        love.graphics.rectangle("fill", x + width * i, self.height, width, self.height)
        style:set_color(style.fg, a, 0.0, 1.0, 0.0)
        love.graphics.printf("G "..config.bits.g, x + width * i, self.height, width, "center")

        i = i + 1
        a = self.active == i

        style:set_color(style.bg, a)
        love.graphics.rectangle("fill", x + width * i, self.height, width, self.height)
        style:set_color(style.fg, a, 0.0, 0.0, 1.0)
        love.graphics.printf("B "..config.bits.b, x + width * i, self.height, width, "center")

        love.graphics.setColor(config.background.color.r, config.background.color.g, config.background.color.b)
        love.graphics.line(x, self.height, x + width * 3, self.height)
        love.graphics.line(x + width, self.height, x + width, self.height * 2)
        love.graphics.line(x + width * 2, self.height, x + width * 2, self.height * 2)
    end,

    draw_color = function(self, x, width)
        style:set_color(style.bg, false)
        love.graphics.rectangle("fill", x, 0, width * 0.3, self.height)
        style:set_color(style.fg, false)
        love.graphics.printf("MODE", x, 0, width * 0.3, "center")

        style:set_color(style.bg, false)
        love.graphics.rectangle("fill", x + width * 0.3, 0, width * 0.7, self.height)
        style:set_color(style.fg, false)
        love.graphics.printf("COLOR", x + width * 0.3, 0, width * 0.7, "center")

        style:set_color(style.bg, self.active == 3)
        love.graphics.rectangle("fill", x, self.height, width * 0.3, self.height)
        style:set_color(style.fg, self.active == 3)
        love.graphics.printf(config.modes.rgb.text, x, self.height, width * 0.3, "center")

        love.graphics.setColor(self.color.x, self.color.y, self.color.z)
        love.graphics.rectangle("fill", x + width * 0.3, self.height, width * 0.7, self.height)
        love.graphics.setColor(self.color.text.color, self.color.text.color, self.color.text.color)
        love.graphics.printf(self.color.text.str, x + width * 0.3, self.height, width * 0.7, "center")

        love.graphics.setColor(config.background.color.r, config.background.color.g, config.background.color.b)
        love.graphics.line(x, self.height, x + width, self.height)
        love.graphics.line(x + width * 0.3, 0, x + width * 0.3, self.height * 2)
    end,

    draw = function(self)
        self:draw_bits(100, 100)
        self:draw_color(500, 700)

        love.graphics.setColor(1.0, 1.0, 1.0)
    end,

    update_color = function(self, x, y)
        if
            (
                image.y ~= 0 and (
                    y < image.y * image.scale or
                    y > window.height - image.y * image.scale
                )
            ) or (
                image.x ~= 0 and (
                    x < image.x * image.scale or
                    x > window.width - image.x * image.scale
                )
            )
        then
            return
        end

        if image.y ~= 0 then
            y = y - image.y * image.scale
        end
        if image.x ~= 0 then
            x = x - image.x * image.scale
        end

        x = math.floor(x / image.scale)
        y = math.floor(y / image.scale)

        if x == mouse.last.x and y == mouse.last.y then
            return
        end

        mouse.last.x = x
        mouse.last.y = y

        self.color.x, self.color.y, self.color.z = image.data:getPixel(x, y)

        self.color.text.color = math.sqrt(
            self.color.x ^ 2 * 0.299 +
            self.color.y ^ 2 * 0.587 +
            self.color.z ^ 2 * 0.114
        ) > 0.5 and 0.0 or 1.0

        if config.mode == config.modes.rgb_normalized.index then
            self.color.text.str = self.color.x..", "..self.color.y..", "..self.color.z
        elseif config.mode == config.modes.rgb.index then
            self.color.text.str = math.floor(self.color.x * 255 + 0.5)
                ..", "
                ..math.floor(self.color.y * 255 + 0.5)
                ..", "
                ..math.floor(self.color.z * 255 + 0.5)
        end
    end,

    mousemoved = function(self, x, y)
        self:update_color(x, y)
    end,

    update_selected = function(self, key)
        print(key)
    end,

    keypressed = function(self, key)
        self:update_selected(key)
    end
}

love.load = function(args)
    config.bits.r = 3
    config.bits.g = 3
    config.bits.b = 2

    config.bits.total.r = 2 ^ config.bits.r
    config.bits.total.g = 2 ^ config.bits.g
    config.bits.total.b = 2 ^ config.bits.b

    image.width  = config.bits.total.r * config.bits.total.b
    image.height = config.bits.total.g

    image.data = love.image.newImageData(image.width, image.height)

    for y = 0, config.bits.total.g - 1 do
        for x1 = 0, config.bits.total.r - 1 do
            for x2 = 0, config.bits.total.b - 1 do
                image.data:setPixel(
                    x1 * config.bits.total.b + x2,
                    y,
                    1 / (config.bits.total.r - 1) * x1,
                    1 / (config.bits.total.g - 1) * y,
                    1 / (config.bits.total.b - 1) * x2,
                    1.0
                )
            end
        end
    end

    image.data:encode("png", "colors.png")

    love.window.maximize()

    window.width  = love.graphics.getWidth()
    window.height = love.graphics.getHeight()

    window.ratio.width  = window.width  / image.width
    window.ratio.height = window.height / image.height

    if image.height * window.ratio.width > window.height then
        image.scale = window.ratio.height
        image.x     = (window.width  * 0.5 / image.scale) - (image.width  * 0.5)
    else
        image.scale = window.ratio.width
        image.y     = (window.height * 0.5 / image.scale) - (image.height * 0.5)
    end

    image.drawable = love.graphics.newImage(image.data)
    image.drawable:setFilter("nearest", "nearest")

    love.graphics.setBackgroundColor(config.background.color.r, config.background.color.g, config.background.color.b)
    love.graphics.setLineWidth(3)
    love.graphics.setNewFont("assets/fonts/"..config.font, config.fontsize)
end

love.draw = function()
    image:draw()
    ui:draw()
end

love.mousemoved = function(x, y)
    ui:mousemoved(x, y)
end

love.keypressed = function(key)
    if key == "escape" then
        love.event.quit(0)
    end

    ui:keypressed(key)
end
