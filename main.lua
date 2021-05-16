
-- push = require 'push' 

require 'game'

WINDOW_WIDTH = 625
WINDOW_HEIGHT = 625

-- VIRTUAL_WIDTH = 432
-- VIRTUAL_HEIGHT = 243

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Snake')

    smallFont = love.graphics.newFont('font.ttf', 12)
    largeFont = love.graphics.newFont('font.ttf', 40)
    love.graphics.setFont(smallFont)

    -- push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    --     fullscreen = false,
    --     resizable = true,
    --     vsync = true
    -- })

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    sounds = {
        ['collect_apple'] = love.audio.newSource('sounds/collect_apple.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    }

    -- love.window.console = true

    -- love.window.setPosition(200, 10, 1)
    
    interval = 35

    add_apple()

end

-- function love.resize(w, h)
--     push:resize(w, h)
-- end

function love.update()
    
    if state == GameState.running then
        interval = interval - 1
        if interval < 0 then 
            game_update()
            if tail_length <= 5 then
                interval = 35
            elseif tail_length > 5 and tail_length <=10 then
                interval = 30
            elseif tail_length > 10 and tail_length <= 15 then
                interval = 25
            else
                interval = 15
            end
        end
    end
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' and state == GameState.start then
        state = GameState.running
    elseif key == 'enter' or key == 'return' and state == GameState.game_over then
        game_restart()
    end

    if key == 'left' and state == GameState.running then
        left = true; right = false; up = false; down = false
    elseif key == 'right' and state == GameState.running then
        left = false; right = true; up = false; down = false
    elseif key == 'up' and state == GameState.running then
        left = false; right = false; up = true; down = false
    elseif key == 'down' and  state == GameState.running then
        left = false; right = false; up = false; down = true
    end

end

function love.draw()

    if state == GameState.start then
        love.graphics.clear(173/255, 216/255, 230/255, 255/255)
        love.graphics.setFont(largeFont)
        love.graphics.printf("Welcome to Snake!", 0, 230, WINDOW_WIDTH, 'center')
        love.graphics.printf("Press Enter to begin", 0, 280, WINDOW_WIDTH, 'center')
    elseif state == GameState.running then
        love.graphics.clear(173/255, 216/255, 230/255, 255/255)
        game_draw()
    elseif state == GameState.game_over then
        love.graphics.clear(173/255, 216/255, 230/255, 255/255)
        love.graphics.setFont(largeFont)
        love.graphics.printf("Game Over!", 0, 230, WINDOW_WIDTH, 'center')
        love.graphics.printf('Score: ' ..tail_length, 0, 280, WINDOW_WIDTH, 'center')
        love.graphics.printf("Press Enter to restart", 0, 330, WINDOW_WIDTH, 'center')
    end
end
