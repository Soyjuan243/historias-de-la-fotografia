local puzzleSystem = {}

puzzleSystem.currentInput = ""
puzzleSystem.feedback = ""
puzzleSystem.isCorrect = false

function puzzleSystem.reset()
    puzzleSystem.currentInput = ""
    puzzleSystem.feedback = ""
    puzzleSystem.isCorrect = false
end

function puzzleSystem.setInput(text)
    puzzleSystem.currentInput = text
end

function puzzleSystem.check(validator, solution)
    local success, message = validator.validate(puzzleSystem.currentInput, solution)
    puzzleSystem.isCorrect = success
    puzzleSystem.feedback = message
    return success
end

return puzzleSystem
