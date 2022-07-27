local sway = false
local normal = true

-- this gets called starts when the level loads.
function start(song) -- arguments, the song name

end

-- this gets called every frame
function update(elapsed) -- arguments, how long it took to complete a frame
    if sway then
		local currentBeat = (songPos / 1000)*(bpm/60)
        if sway then
		    for i=0,7 do
			    setActorX(_G['defaultStrum'..i..'X'] + 6 * math.sin((currentBeat + i*0.25) * math.pi), i)
			    setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.10) * math.pi), i)
		    end
        end
	if normal then
        	for i=0,7 do
			    setActorX(_G['defaultStrum'..i..'X'],i)
			    setActorY(_G['defaultStrum'..i..'Y'],i)
			end
        end
    end
end

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function returnCam()
    tweemCameraZoom(1, 0.1)
end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
    if step == 100 then
        tweenCameraZoom(1.5, 2.37, 'returnCam')
    end
    if step == 128 then
        sway = true
        normal = false
    end
    if step == 384 then
        sway = true
        for i = 0, 3 do
            tweenFadeOut(i, 0, 0.3)
        end
        for i = 4, 7 do -- go to the center
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i) + 360, 0.3, 'setDefault')
        end
    end
    if step == 511 then
        tweenCameraZoom(1.4, 10.05, 'returnCam')
        sway = false
        normal = true
    end
    if step == 638 then
        for i = 0, 3 do
            tweenFadeIn(i, 1, 0.4)
        end
        for i = 4, 7 do -- go to the center
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 275,getActorAngle(i) - 360, 0.3, 'setDefault')
        end
    end
       if step == 832 then
        sway = true
        normal = false
    end
    if step == 894 then
        sway = false
    end
     if step == 1005 then
        tweenCameraZoom(1.5, 1.57, 'returnCam')
    end
    if step == 1023 then
        sway = true
    end
    if step == 1279 then
        sway = false
        normal = true
    end
end

print('dadbattle modchart loaded')