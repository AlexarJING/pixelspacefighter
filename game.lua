game={}
function game.generateSpark(x,y,rot,sep,size,amount)
	sparks=sparks or {}
	for i=1,amount do
		--x,y,rot,speed,size,lifeTime
		local spark=makeSpark(x,y,rot-sep/2+i*sep/amount+love.math.random(-2*sep/amount,2*sep/amount),love.math.random(5,10),1,0.3)
	end
end
function math.axisRot(x,y,rot)
	local xx=math.cos(rot)*x-math.sin(rot)*y
	local yy=math.cos(rot)*y+math.sin(rot)*x
	return xx,yy
end

function math.getRot(x1,y1,x2,y2,toggle)
	if x1==x2 and y1==y2 then return end 
	angle=math.atan((x1-x2)/(y1-y2))
	if y1-y2<0 then angle=angle-math.pi end
	if toggle==true then angle=angle+math.pi end
	if angle>0 then angle=angle-2*math.pi end
	if angle==0 then return 0 end
	return -angle
	
end

function math.getDistance(x1,y1,x2,y2)
	return ((x1-x2)^2-(y1-y2)^2)^0.5
end

function game.collision(a, b)
	local obja,objb=a:getUserData(),b:getUserData()
	if (obja.class=="ship" or obja.class=="comet") and objb.class=="bullet" then
		game.generateSpark(objb.x,objb.y,objb.rot+math.pi,math.pi,0.5,10)
		objb.remove=true
	end
	--[[if (b.parent.class=="ship" or b.parent.class=="comet") and a.parent.class=="bullet" then
		local bullet=a.parent
		game.generateSpark(bullet.x,bullet.y,bullet.rot+math.pi,math.pi,0.5,10)
		bullet.remove=true
	end]]

end



--collider:setCallbacks(game.collision)