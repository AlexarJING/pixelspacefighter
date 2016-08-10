ships={}
local ship=class{
	init=function(self,x,y,rot,type,size,ctrl_type)
		---飞机编号
		shipID=shipID or 0
		shipID=shipID+1
		self.id=shipID
		self.class="ship"
		self.type=type
		self.size=size
		---------------
		self.x=x
		self.y=y
		self.rot=rot
		-----------
		self.fireRate=5
		self.cd=0
		self.speed=0
		self.speed_max=10
		------
		if self.type=="disk" then
			self.shape=30*self.size
			self.bb=collision.addShape("circle",self.shape)
		elseif self.type=="arrow" then
			self.shape={0,35*self.size,15*self.size,-15*self.size,0,0,-15*self.size,-15*self.size}
			self.bb=collision.addShape("polygon",self.shape)
		elseif self.type=="drip" then
			self.shape={0,25*self.size,15*self.size,-15*self.size,-15*self.size,-15*self.size}
			self.bb=collision.addShape("polygon",self.shape)
		end
		self.ctrl_type=ctrl_type or "user"
		if self.ctrl_type=="user" then
			game.hero=self
		end
		-----------------------------------
		self.bb.fixture:setUserData(self)
		collision.setPara(self.bb,self.x,self.y,self.rot)
		table.insert(ships, self)
		self.bb.fixture:setGroupIndex(-self.id)
	end
}



function ship:rotedShape(abs)
	local tab={}
	abs=abs or 0
	for i=1,#self.shape/2 do
		tab[2*i-1],tab[2*i]=math.axisRot(self.shape[2*i-1],self.shape[2*i],self.rot)
		tab[2*i-1]=tab[2*i-1]+self.x*abs
		tab[2*i]=tab[2*i]+self.y*abs
	end
	return tab
end

function ship:draw()
	if self.type=="arrow" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.polygon("fill", self:rotedShape(1))
		love.graphics.setColor(100, 100, 100, 255)
		love.graphics.setLineWidth(2)
		love.graphics.polygon("line", self:rotedShape(1))
	elseif self.type=="disk" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.circle("fill", self.x,self.y,15*self.size)
		love.graphics.setColor(230, 50, 50, 255)
		local rx,ry=math.axisRot(0,15*self.size,self.rot)
		love.graphics.line(self.x,self.y, self.x+rx,self.y+ry )
	elseif self.type=="drip" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.polygon("fill", self.bb.body:getWorldPoints(self.bb.shape:getPoints()))
		local rx,ry=math.axisRot(0,3*self.size,self.rot+math.pi)
		love.graphics.circle("fill", self.x+rx, self.y+ry, 15*self.size)
	end
end

function ship:update()
	self.x,self.y,self.rot=collision.getPara(self.bb)
	self:ctrl()
end

function ship:ctrl()
	if self.ctrl_type~="user" then return end
	if self.type=="arrow" then
		if love.mouse.isDown("l") and self.cd<=0 then
			local rx,ry=math.axisRot(0,-30*self.size,self.rot+math.pi)
			local bullet=makeBullet(self,rx+self.x,ry+self.y,self.rot+math.pi,10*60,"ball",2,1,30)
			self.cd=1/self.fireRate
		end
		self.cd=self.cd-1/20
		if  love.keyboard.isDown("w") then
			collision.go(self,1)
		end
		if  love.keyboard.isDown("s") and (not self.turn) then
			self.turn=true
		end
		if self.turn and (not love.keyboard.isDown("s")) then
			self.bb.body:setAngularVelocity(0)
			self.rot=self.rot+math.pi
			collision.setPara(self.bb,self.x,self.y,self.rot)
			self.turn=false
		end
		if  love.keyboard.isDown("a") then
			self.rot=self.rot-math.pi/30
			self.bb.body:setAngularVelocity(0)
			collision.setPara(self.bb,self.x,self.y,self.rot)
		end
		if  love.keyboard.isDown("d") then
			self.rot=self.rot+math.pi/30
			self.bb.body:setAngularVelocity(0)
			collision.setPara(self.bb,self.x,self.y,self.rot)
		end
		if self.speed>self.speed_max then self.speed=self.speed_max end
		if self.speed<-self.speed_max then self.speed=-self.speed_max end

	elseif self.type=="disk" then

	elseif self.type=="drip" then
	end
end



return ship