camera={
	x=0,
	y=0,
	heroX=0,
	heroY=0,
	heroLock=-1
}
love.graphics.push()
function camera:setPos(x,y)
	self.x=x
	self.y=y
	love.graphics.pop()
	love.graphics.push()
	love.graphics.translate(x,y)
end

function camera:reset()
	love.graphics.origin()
	self.x=0
	self.y=0
	self.heroLock=1
end

function camera:follow()
	if self.heroLock==-1 then return end
	if self.heroLock==1 then
		love.graphics.translate(512-game.hero.x,300-game.hero.y)
		self.x=512-game.hero.x
		self.y=300-game.hero.y
	end
	if self.heroLock==0 then
		if 512-game.hero.x>300 then
			love.graphics.translate(212-game.hero.x,0)
		end
		if 512-game.hero.x<-300 then
			love.graphics.translate(812-game.hero.x,0)
		end
		if 300-game.hero.y>200 then
			love.graphics.translate(0,100-game.hero.y)
		end
		if 300-game.hero.y<-200 then
			love.graphics.translate(0,500-game.hero.y)
		end
	end
end