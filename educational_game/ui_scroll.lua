local scroll = {}

function scroll.new(x, y, w, h)
    return {
        x = x, y = y, w = w, h = h,
        scrollY = 0,
        contentHeight = 0,
        padding = 10
    }
end

function scroll.draw(self, drawFunc)
    love.graphics.setScissor(self.x, self.y, self.w, self.h)
    love.graphics.push()
    love.graphics.translate(0, -self.scrollY)

    local startY = self.y + self.scrollY
    drawFunc(self.x + self.padding, self.y + self.padding, self.w - self.padding * 2)

    love.graphics.pop()
    love.graphics.setScissor()

    -- Scrollbar
    if self.contentHeight > self.h then
        local barH = (self.h / self.contentHeight) * self.h
        local barY = self.y + (self.scrollY / self.contentHeight) * self.h
        love.graphics.setColor(1, 1, 1, 0.3)
        love.graphics.rectangle("fill", self.x + self.w - 5, barY, 4, barH, 2)
    end
end

function scroll.wheelmoved(self, y)
    self.scrollY = math.max(0, math.min(self.contentHeight - self.h, self.scrollY - y * 20))
end

return scroll
