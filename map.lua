map={}
map.around={}
map.x=math.floor(game.hero.x/1024)
map.y=math.floor(game.hero.y/600)

function map.create(mapx,mapy)
	local amount=6
	for i=1,amount do
		local x = love.math.random(mapx*1024,(mapx+1)*1024)
		local y = love.math.random(mapy*600,(mapy+1)*600)
		local rot = love.math.random()*2*math.pi
		local size = love.math.random()+0.1
		local speed = love.math.random(0,5)
		local selfRot  = love.math.random()/100
		makeComet(x,y,rot,size,0,selfRot)
	end
end

function map.destroy()
	for k,v in pairs(comets) do
		if math.getDistance(game.hero.x,game.hero.y,v.x,v.y)>2*1024 then
			v.remove=true
		end
	end
	collectgarbage("collect")
end

function map.check()
	map.x=math.floor(game.hero.x/1024)
	map.y=math.floor(game.hero.y/600)
	for xx=-3,3 do
		for yy=-3,3 do 
			if xx==-3 or xx==3 or yy==-3 or yy==3 then
				map.around[tostring(xx+map.x)..","..tostring(yy+map.y)]=false
			else
				if not map.around[tostring(xx+map.x)..","..tostring(yy+map.y)] then
					map.around[tostring(xx+map.x)..","..tostring(yy+map.y)]=true
					map.create(xx+map.x,yy+map.y)
				end
			end
		end
	end
	map.destroy()
	print(#comets)
end