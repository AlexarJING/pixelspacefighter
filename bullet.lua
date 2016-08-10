bullets={}
local bullet=class{
	init=function(self,parent,x,y,rot,speed,type,lifeTime,size,damage)
		self.class="bullet"
		self.parent=parent
		self.x=x
		self.y=y
		self.rot=rot
		self.speed=speed
		self.type=type
		self.lifeTime=lifeTime
		self.damage=damage
		self.size=size
		self.userData=userData
		if self.type=="ball" then
			self.bb=collision.addShape("circle",3*self.size)
		elseif self.type=="line" then
			self.bb=collision.addShape("polygon",{1,10,-1,-10,-1,-10})
			---1, -10*self.size, 1,-10*self.size,1,10*self.size,-1,10*self.size
		end
		self.bb.fixture:setUserData(self)
		table.insert(bullets, self)
		collision.setPara(self.bb,self.x,self.y,self.rot,self.speed)
		self.bb.fixture:setGroupIndex(0)
		self.bb.fixture:setGroupIndex(-self.parent.id)
	end
}

function bullet:draw()
	love.graphics.setColor(255, 0, 0, 255)
	if self.type=="ball" then
		love.graphics.circle("fill", self.x, self.y, 3*self.size)
	elseif self.type=="line" then
		love.graphics.setLineWidth(2*self.size)
		local rx,ry=math.axisRot(0,10*self.size,self.rot)
		love.graphics.line(self.x,self.y, self.x+rx,self.y+ry )
	end
end


function bullet:update()
	self.x,self.y,self.rot=collision.getPara(self.bb)
	self.lifeTime=self.lifeTime-1/20
	if self.lifeTime<=0 then 
		self.remove=true 
	end
end

function bullet:collision()

end

return bullet