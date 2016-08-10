love.math.setRandomSeed(os.time())
require("game")
require("collision")
--collider=require("HardonCollider")(100)
input=require("input")
class=require("class")
makeBullet=require("bullet")
makeSpark=require("spark")
makeShip=require("spaceship")
myShip=makeShip(100,100,0,"arrow",0.8)
require("camera")
makeComet=require("comet")
require("map")
function love.load()
   aiShip=makeShip(400,400,0,"arrow",1,"ai")
end

function love.draw()
    camera:follow()

    for k,v in pairs(ships) do
    	v:draw()
    	love.graphics.setColor(255, 255, 255, 255)
   		--v.bb:draw()
    end
    for k,v in pairs(bullets) do
    	v:draw()
    	love.graphics.setColor(255, 255, 255, 255)
    	--v.bb:draw("line")
    end
    for k,v in pairs(sparks) do
    	v:draw()
    end
    for k,v in pairs(comets) do
    	v:draw()
    	love.graphics.setColor(255, 0, 255, 255)
    	--v.bb:draw("line")
    end
end

function love.update(dt)
	map.check()
	inputTest=input:test()
	inputTest_r=input:test_r()
	for k,v in pairs(ships) do
    	v:update(dt)
    	if v.remove==true then
    		--table.remove(ships, k)
    	end
    end

	for k,v in pairs(bullets) do
    	v:update(dt)
    	if v.remove==true then
    		--table.remove(bullets, k)
    	end
    end
	for k,v in pairs(sparks) do
    	v:update(dt)
    	if v.remove==true then
    		table.remove(sparks, k)
    	end
    end
	for k,v in pairs(comets) do
    	v:update(dt)
    	if v.remove==true then
    		--table.remove(comets, k)
    	end
    end
    collision.world:update(dt)
end