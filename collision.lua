collision={}
love.physics.setMeter(64)
collision.world = love.physics.newWorld(0, 0, false)
collision.world:setCallbacks( nil, nil , game.collision, nil )
function collision.addShape(type,...)
	local obj={}
	obj.body=love.physics.newBody(collision.world, 0, 0,"dynamic")
	if type=="circle" then
		obj.shape=love.physics.newCircleShape(...)
	elseif type=="polygon" then 
		obj.shape = love.physics.newPolygonShape(...)
	end
	obj.fixture = love.physics.newFixture(obj.body, obj.shape, 1) 
	return obj
end


function collision.getPara(obj)
	local x,y,r
	x,y=obj.body:getPosition()
	r=obj.body:getAngle()
	return x,y,r
end
function collision.setPara(obj,x,y,rot,speed)
	obj.body:setPosition(x,y)
	obj.body:setAngle(rot)
	if speed~=nil then
		local sx=math.sin(rot)*speed
		local sy=-math.cos(rot)*speed
		obj.body:setLinearVelocity(sx,sy)
	end
end

function collision.go(owner,force,rad)
	--力分解
	rad=rad or owner.rot+math.pi
	local fx=math.sin(rad)*force
	local fy=-math.cos(rad)*force
	owner.bb.body:applyForce(fx,fy)
	owner.bb.body:applyLinearImpulse( fx, fy )
end

function collision.turn(owner,torque)
	owner.bb.body:applyTorque( torque )
end
