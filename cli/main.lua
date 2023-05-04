-- matexture (cli)

require("io")

love.load = function(args)
    local r = 2 ^ tonumber(args[1])
    local g = 2 ^ tonumber(args[2])
    local b = 2 ^ tonumber(args[3])

    local w = r * b
    local h = g

    local data = love.image.newImageData(w, h)

    for y = 0, g - 1 do
        for x1 = 0, r - 1 do
            for x2 = 0, b - 1 do
                data:setPixel(
                    x1 * b + x2,
                    y,
                    1 / (r - 1) * x1,
                    1 / (g - 1) * y,
                    1 / (b - 1) * x2,
                    1.0
                )
            end
        end

        io.write("generating.. ("..math.floor((y / (g-1) * 100) + 0.5).."%)\r")
    end

    io.write("\nencoding..         ")
    data:encode("png", "matexture_"..table.concat(args, "_")..".png")

    print("\nsaved in %appdata%/love/"..love.filesystem.getIdentity().."/")
    love.event.quit()
end
