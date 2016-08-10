comets={}


local comet=class{
	init=function(self,x,y,rot,size,speed,selfRot)
		self.class="comet"
		self.x=x
		self.y=y
		self.rot=rot
		self.size=size
		self.speed=speed
		self.selfRot=selfRot
		self.shape=self:generatePolygon(size)
		self.dx=math.sin(self.rot)*self.speed
		self.dy=-math.cos(self.rot)*self.speed
		self.bb=collider:addPolygon(unpack(self.shape))
		self.bb.parent=self
		self.bboffx,self.bboffy=self.bb:center()
		self.speed_max=10
		self.rad=self.rot
		table.insert(comets,self)
		self:shapeUnit()
	end
}

function comet:shapeUnit()
	for i=1,#self.shape/2 do
		self.shape[2*i-1]=self.shape[2*i-1]-self.bboffx
		self.shape[2*i]=self.shape[2*i]-self.bboffy
	end
	return tab
end

function comet:generatePolygon(size)
	local v={}
	local rt={}
	local lastK=0
	local lastX=0
	local lastY=0
	local lastRad=0
	local v_c=love.math.random(10,30)
	for i=1,v_c do
		v[i]={}
		v[i].x=love.math.random(-50,50)*size
		v[i].y=love.math.random(-50,50)*size
	end
	local maxY=-50*size
	local oK=0
	for k,v in pairs(v) do
		if v.y>maxY then
			maxY=v.y
			oK=k
		end	
	end
	lastK=oK
	lastX=v[lastK].x
	lastY=v[lastK].y
	table.insert(rt,v[lastK].x)
	table.insert(rt,v[lastK].y)
	local i=0
	while i<100 do
		i=i+1
		local minRad=2*math.pi
		local minK=0
		for k,v in pairs(v) do
			local rad=math.getRot(lastX,lastY,v.x,v.y,true)
			if rad and rad>lastRad then
				if rad<minRad then
					minRad=rad
					minK=k
				end
			end
		end
		if minK==maxK or minK==0 then return rt end
		lastK=minK
		lastRad=minRad
		lastX=v[lastK].x
		lastY=v[lastK].y
		table.insert(rt,v[lastK].x)
		table.insert(rt,v[lastK].y)
	end
end

function comet:rotedShape()
	local tab={}
	for i=1,#self.shape/2 do
		tab[2*i-1],tab[2*i]=math.axisRot(self.shape[2*i-1],self.shape[2*i],self.rad)
		tab[2*i-1]=tab[2*i-1]+self.x
		tab[2*i]=tab[2*i]+self.y
	end
	return tab
end

function comet:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.polygon("line", self:rotedShape())
	love.graphics.circle("fill", self.x,self.y, 3)
end


function comet:bbUpdate()
	self.bb:setRotation(self.rad)
	self.bb:moveTo(self.x,self.y)
end

function comet:update()
	self.dx=math.sin(self.rot)*self.speed
	self.dy=-math.cos(self.rot)*self.speed
	self.x=self.x+self.dx
	self.y=self.y+self.dy
	self.rad=self.rad+self.selfRot
	self:bbUpdate()
end

return comet