local ui = {}

function ui.panel(x, y, w, h, color)
    love.graphics.setColor(color or {0.1, 0.1, 0.1, 0.8})
    love.graphics.rectangle("fill", x, y, w, h, 10)
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.rectangle("line", x, y, w, h, 10)
end

function ui.title(text, x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(text, x, y, 0, 1.5, 1.5)
end

function ui.label(text, x, y, color)
    love.graphics.setColor(color or {1, 1, 1})
    love.graphics.print(text, x, y)
end

return ui
