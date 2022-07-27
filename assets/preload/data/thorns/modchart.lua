local move1 = false
local move2 = false
local crazy = false
local sway = false

function start(song) -- do nothing

end

function update(elapsed)
    -- take the l i just yoinked this from strung up
    if move1 then
        local currentBeat = (songPos / 1000)*(bpm/170)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 12 * math.sin((currentBeat + i*0.05) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 4 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	if move2 then
        local currentBeat = (songPos / 1000)*(bpm/170)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 24 * math.sin((currentBeat + i*0.05) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
	if crazy then
        local currentBeat = (songPos / 1000)*(bpm/170)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 36 * math.sin((currentBeat + i*0.05) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 26 * math.cos((currentBeat + i*0.31) * math.pi), i)
        end
    end
    if sway then
		local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 6 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.10) * math.pi), i)
        end
    end 
end

function returnCam()
    tweemCameraZoom(1, 0.1)
end

function beatHit(beat) -- do nothing

end

function stepHit(step) -- do nothing
    if step == 256 then
    move2 = true
    tweenFadeOut('girlfriend', 0.0, 0.5)
    tweenFadeOut('boyfriend', 0.0, 0.5)
    end
    if step == 320 then
    tweenFadeOut('dad', 0.0, 0.5)
    tweenFadeIn('girlfriend', 1, 0.5)
    tweenFadeIn('boyfriend', 1, 0.5)
    end
    if step == 384 then
    tweenFadeOut('dad', 1, 0.5)
    end
    if step == 640 then
        move2 = false
        crazy = true
    end
    if step == 768 then
    tweenFadeOut('girlfriend', 0.0, 0.5)
    tweenFadeOut('boyfriend', 0.0, 0.5)
    end
    if step == 832 then
    tweenFadeOut('dad', 0.0, 0.5)
    tweenFadeIn('girlfriend', 1, 0.5)
    tweenFadeIn('boyfriend', 1, 0.5)
    end
    if step == 896 then
       tweenFadeOut('dad', 1, 0.5)
       crazy = false
       sway = true
    end
    if step == 1024 then
    tweenFadeOut('girlfriend', 0.0, 0.5)
    tweenFadeOut('boyfriend', 0.0, 0.5)
    end
    if step == 1088 then
    tweenFadeOut('dad', 0.0, 0.5)
    tweenFadeIn('girlfriend', 1, 0.5)
    tweenFadeIn('boyfriend', 1, 0.5)
    end
    if step == 1152 then
    tweenFadeOut('dad', 1, 0.5)
    sway = false
    end
end

function playerTwoTurn()

end

function playerOneTurn()

end