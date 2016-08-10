sparks={}
local spark=class{
	init=function(self,x,y,rot,speed,size,lifeTime)
		self.x=x
		self.y=y
		self.rot=rot
		self.speed=speed
		self.lifeTime=lifeTime
		self.size=size
		---diversion=0~2pi
		table.insert(sparks, self)
	end
}

function spark:draw()
	love.graphics.setColor(255, 255, 0, 255)
	local rx,ry=math.axisRot(0,10*self.size,self.rot)
	love.graphics.setLineWidth(self.size)
	love.graphics.line(self.x,self.y, self.x+rx,self.y+ry )
end


function spark:update()
	self.x=self.x+math.sin(self.rot)*self.speed
	self.y=self.y-math.cos(self.rot)*self.speed
	self.lifeTime=self.lifeTime-1/20
	if self.lifeTime<=0 then 
		self.remove=true 
	end
end

return spark