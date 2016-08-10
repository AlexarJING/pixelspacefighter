local input={
	clickToggle=false,
	clickToggle_r=false,
	lastDown=0,
	lastDown_r=0,
	ox=0,
	oy=0
}
function input:test()
	local dt=love.timer.getTime()-self.lastDown
	local tx,ty = love.mouse.getPosition()
	local dx,dy=tx-self.ox,ty-self.oy
	local ml=((dx)^2+(dy)^2)^0.5
	if love.mouse.isDown("l") and self.clickToggle==false then
		self.clickToggle=true
		self.lastDown = love.timer.getTime()
		self.ox=tx
		self.oy=ty
		return "down"
	end	
	if dt>0.2 and self.clickToggle==true and love.mouse.isDown("l") then
		if ml>20 then
			if dy>50 then return "sweepingDown" end
			if dy<-50 then return "sweepingUp" end
			if dx>50 then return "sweepingRight" end
			if dx<-50 then return "sweepingLeft" end
		else
			return "holding"
		end
	end
	if not love.mouse.isDown("l") and self.clickToggle==true then
		self.clickToggle=false
		if dt<=0.2 then
			return "clicked"
		else
			if ml<20 then return "held" end
			if dy>50 then return "sweptDown" end
			if dy<-50 then return "sweptUp" end
			if dx>50 then return "sweptRight" end
			if dx<-50 then return "sweptLeft" end
		end
		self.lastDown = 0
	end
end


function input:test_r()
	local dt_r=love.timer.getTime()-self.lastDown_r
	local mx,my = love.mouse.getPosition()
	if love.mouse.isDown("r") and self.clickToggle_r==false then
		self.clickToggle_r=true
		self.lastDown_r = love.timer.getTime()
		return "down"
	end	
	if dt_r>0.2 and self.clickToggle_r==true and love.mouse.isDown("r") then
		return "dragging"
	end
	if not love.mouse.isDown("r") and self.clickToggle_r==true then
		self.clickToggle_r=false
		if dt_r<=0.2 then
			return "clicked"
		else
			return "dragged"
		end
	end
	return "ready"
end



return input