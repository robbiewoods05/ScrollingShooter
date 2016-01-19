local Gamestate = {}

local state = nil

local lastState = nil

function Gamestate.IsState(gamestate)
    return state == gamestate
end

function Gamestate.GetState()
    return state
end

function Gamestate.SetState(gamestate)
    lastState = state
    state = gamestate
end

function Gamestate.LastState()
    state = lastState
end

return Gamestate
