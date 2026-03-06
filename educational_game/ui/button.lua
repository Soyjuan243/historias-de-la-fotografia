local button = {}

function button.new(text, x, y, w, h, onClick, theme)
    return {
        text = text,
        x = x,
        y = y,
        w = w,
        h = h,
        onClick = onClick,
        theme = theme or {0.2, 0.2, 0.2},
        isHovered = false
    }
end

function button.update(self, mx, my)
    self.isHovered = mx >= self.x and mx <= self.x + self.w and
                     my >= self.y and my <= self.y + self.h
end

function button.draw(self)
    local color = self.isHovered and {self.theme[1]*1.5, self.theme[2]*1.5, self.theme[3]*1.5} or self.theme
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 5)

    love.graphics.setColor(1, 1, 1)
    local tw = love.graphics.getFont():getWidth(self.text)
    local th = love.graphics.getFont():getHeight()
    love.graphics.print(self.text, self.x + (self.w - tw)/2, self.y + (self.h - th)/2)
end

function button.mousepressed(self, x, y, button)
    if self.isHovered and button == 1 then
        self.onClick()
        return true
    end
    return false
end

return button
