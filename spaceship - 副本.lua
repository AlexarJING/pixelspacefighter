ships={}
local ship=class{
	init=function(self,x,y,rot,type,ctrl_type) --type="arrow","disk","drip"
		----基本位置
		shipID=shipID or 0
		shipID=shipID+1
		self.class="ship"
		self.name=tostring(shipID)
		self.type=type
		self.x=x
		self.y=y
		self.rot=rot
		self.size=1.5
		self.dx=0
		self.dy=0
		self.ax=0 --加速度分量
		self.ay=0
		self.acc=0.1 --加速度
		self.acc_rad=0 --加速度角度
		if self.type=="arrow" then
			self.shape={0,20,10,-10,0,0,-10,-10}
		else
			self.shape={0,30,10,0,-10,0}
		end
		self.bb=collision.addShape("polygon",self:rotedShape())
		--collider:addToGroup(self.name, self.bb)
		self.bb.parent=self
		self.speed_max=8
		self.speed=0
		self.turn=false
		self.tx=0
		self.ty=0
		self.ctrl_type=ctrl_type or "user"
		if self.ctrl_type=="user" then
			game.hero=self
		end
		table.insert(ships, self)
		self.fireRate=5
		self.cd=0
		self.hp=100
		self.shell=100
		--self.bboffx,self.bboffy=self.bb:center()
		collision.setPara(self.bb,self.x,self.y,self.rot)
		self.bb.fixture:setUserData(self)
	end
}

function ship:rotedShape(toggle)
	toggle=toggle or 0
	local tab={}
	for i=1,#self.shape/2 do
		tab[2*i-1],tab[2*i]=math.axisRot(self.shape[2*i-1],self.shape[2*i],self.rot+math.pi*toggle)
		tab[2*i-1]=tab[2*i-1]*self.size
		tab[2*i]=tab[2*i]*self.size
	end
	return tab
end

function ship:draw()
	if self.type=="arrow" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.polygon("fill", self:rotedShape())
	elseif self.type=="disk" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.circle("fill", self.x,self.y,15*self.size)
		love.graphics.setColor(230, 50, 50, 255)
		local rx,ry=math.axisRot(0,15*self.size,self.rot)
		love.graphics.line(self.x,self.y, self.x+rx,self.y+ry )
	elseif self.type=="drip" then
		love.graphics.setColor(50, 230, 50, 255)
		love.graphics.polygon("fill", self:rotedShape())
		love.graphics.circle("fill", self.x,self.y,10*self.size)		
	end
end

function ship:bbUpdate()
	self.bb:moveTo(self.x+self.bboffx,self.y+self.bboffy)
	self.bb:setRotation(self.rot)
end

function ship:update()
	self.x,self.y,self.rot=collision.getPara(self.bb)
	self:ctrl()
	--self:bbUpdate()
	--print(self.x,self.y)
end
function ship:moveTo(x,y)
	local rot=math.getRot(self.x,self.y,x,y)
	self.speed=self.speed+self.acc
	self.rot=rot
	self.dx=math.sin(self.rot)*self.speed
	self.dy=-math.cos(self.rot)*self.speed
end

function ship:ctrl()
	if self.ctrl_type~="user" then return end
	if self.type=="arrow" then
		if love.mouse.isDown("l") and self.cd<=0 then
			local rx,ry=math.axisRot(0,-30*self.size,self.rot+math.pi)
			local bullet=makeBullet(self.name,rx+self.x,ry+self.y,self.rot+math.pi,10*60,"ball",2,1,30)
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
		if love.mouse.isDown("l") and self.cd<=0 then
			local mx,my=love.mouse.getPosition()
			local rot=math.getRot(self.x,self.y,mx-camera.x,my-camera.y)
			local rx,ry=math.axisRot(0,-20*self.size,rot)
			local bullet=makeBullet(self.name,rx+self.x,ry+self.y,rot,10,"line",2,1,30)
			self.cd=1/self.fireRate
		end
		self.cd=self.cd-1/20

		if inputTest_r=="clicked" or inputTest_r=="held" then 
			local mx,my=love.mouse.getPosition()
			self.tx,self.ty=mx-camera.x,my-camera.y
			myShip:moveTo(self.tx,self.ty)
		end
		if ((self.dx>0 and self.x>=self.tx) or (self.dx<0 and self.x<=self.tx)) and ((self.dy>0 and self.y>=self.ty) or (self.dy<0 and self.y<=self.ty))  then
			self.dx=0
			self.tx=0
			self.dy=0
			self.ty=0
			self.speed=0
		elseif self.speed~=0 then
			self.speed=self.speed+self.acc
			self.dx=math.sin(self.rot)*self.speed
			self.dy=-math.cos(self.rot)*self.speed
			if self.speed>self.speed_max then self.speed=self.speed_max end
			if self.speed<-self.speed_max then self.speed=-self.speed_max end
		end
		if  love.keyboard.isDown("w") then
			self.ty=self.y-10
			if self.tx==0 then self.tx=self.x end
			myShip:moveTo(self.tx,self.ty)
		end
		if  love.keyboard.isDown("s") then
			self.ty=self.y+10
			if self.tx==0 then self.tx=self.x end
			myShip:moveTo(self.tx,self.ty)
		end
		if  love.keyboard.isDown("a") then
			self.tx=self.x-10
			if self.ty==0 then self.ty=self.y end
			myShip:moveTo(self.tx,self.ty)
		end
		if  love.keyboard.isDown("d") then
			self.tx=self.x+10
			if self.ty==0 then self.ty=self.y end
			myShip:moveTo(self.tx,self.ty)
		end
		--self.rot=self.rot+math.pi/30
	elseif self.type=="drip" then
		if love.mouse.isDown("l") and self.cd<=0 then
			local rx,ry=math.axisRot(0,-20*self.size,self.rot)
			local bullet=makeBullet(self.name,rx+self.x,ry+self.y,self.rot,10,"line",2,1,30)
			self.cd=1/self.fireRate
		end
		self.cd=self.cd-1/20

		if  love.keyboard.isDown("w") then
			self.speed=self.speed_max
		end
		if  love.keyboard.isDown("s") and (not self.turn) then
			self.turn=true
		end
		if love.keyboard.isDown(" ") then
			self.speed=0
		end

		if self.turn and (not love.keyboard.isDown("s")) then
			self.rot=self.rot+math.pi
			self.speed=-self.speed
			self.turn=false
		end
		if  love.keyboard.isDown("a") then
			self.rot=self.rot-math.pi/30
		end
		if  love.keyboard.isDown("d") then
			self.rot=self.rot+math.pi/30
		end
		if self.speed>self.speed_max then self.speed=self.speed_max end
		if self.speed<-self.speed_max then self.speed=-self.speed_max end
		self.dx=math.sin(self.rot)*self.speed
		self.dy=-math.cos(self.rot)*self.speed
	end
end

return ship