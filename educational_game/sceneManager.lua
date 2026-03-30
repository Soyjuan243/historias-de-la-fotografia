local sceneManager = {}

sceneManager.scenes = {}
sceneManager.currentScene = nil
sceneManager.currentSceneName = ""

function sceneManager.register(name, scene)
    sceneManager.scenes[name] = scene
end

function sceneManager.switch(name, ...)
    if sceneManager.scenes[name] then
        if sceneManager.currentScene and sceneManager.currentScene.exit then
            sceneManager.currentScene.exit()
        end

        sceneManager.currentScene = sceneManager.scenes[name]
        sceneManager.currentSceneName = name

        if sceneManager.currentScene.enter then
            sceneManager.currentScene.enter(...)
        end
    end
end

function sceneManager.update(dt)
    if sceneManager.currentScene and sceneManager.currentScene.update then
        sceneManager.currentScene.update(dt)
    end
end

function sceneManager.draw()
    if sceneManager.currentScene and sceneManager.currentScene.draw then
        sceneManager.currentScene.draw()
    end
end

function sceneManager.keypressed(key)
    if sceneManager.currentScene and sceneManager.currentScene.keypressed then
        sceneManager.currentScene.keypressed(key)
    end
end

function sceneManager.mousepressed(x, y, button)
    if sceneManager.currentScene and sceneManager.currentScene.mousepressed then
        sceneManager.currentScene.mousepressed(x, y, button)
    end
end

function sceneManager.wheelmoved(x, y)
    if sceneManager.currentScene and sceneManager.currentScene.wheelmoved then
        sceneManager.currentScene.wheelmoved(x, y)
    end
end

function sceneManager.textinput(text)
    if sceneManager.currentScene and sceneManager.currentScene.textinput then
        sceneManager.currentScene.textinput(text)
    end
end

return sceneManager
