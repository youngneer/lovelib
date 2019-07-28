lovecc=require 'lovecc'

local i,j
local h,k

CIRCLE_GAP=35
CIRCLES_PER_ROW=14
CIRCLE_RADIUS=20

circle_hovered=nil

local colors={}
for a,i in pairs(lovecc) do if type(i)~='function' then colors[a]=i end end

function love.load()

	sound=love.audio.newSource('click.wav','static')
	love.window.setTitle("Color Picker for Love2D")

	--Note that the new version of lovecc doesn't have white by default so this is just a work-around
	lovecc:newColor("white",256,256,256)

	lovecc:setBackgroundColor("maroon")
	love.graphics.setLineWidth(5)
	love.window.setMode(800,565)

end

function love.draw()
	i,j=1,1
	for color_name,code in pairs(colors) do

		h=CIRCLE_GAP+(i-1)*(CIRCLE_RADIUS+CIRCLE_GAP)
		k=CIRCLE_GAP+(j-1)*(CIRCLE_RADIUS+CIRCLE_GAP)
		
		lovecc:setColor('black')
		love.graphics.circle('line',h,k,CIRCLE_RADIUS)
		
		lovecc:setColor(color_name,0.8)
		love.graphics.circle('fill',h,k,CIRCLE_RADIUS)		
		i=i+1
		if i==CIRCLES_PER_ROW+1 then
			i=1
			j=j+1
		end
	end

	if circle_hovered then
		-- lovecc:invertColor(circle_hovered[1],1)
		lovecc:setColor("white",0.6)
		love.graphics.circle('line',circle_hovered[2],circle_hovered[3],CIRCLE_RADIUS)
	end
end


function love.mousemoved(x,y)
	i,j=1,1
	for color_name,code in pairs(colors) do

		h=CIRCLE_GAP+(i-1)*(CIRCLE_RADIUS+CIRCLE_GAP)
		k=CIRCLE_GAP+(j-1)*(CIRCLE_RADIUS+CIRCLE_GAP)
		
		if (x-h)*(x-h) + (y-k)*(y-k) <= CIRCLE_RADIUS*CIRCLE_RADIUS then
			circle_hovered={color_name,h,k}
		end

		i=i+1
		if i==CIRCLES_PER_ROW+1 then
			i=1
			j=j+1
		end
	end
end

function love.mousepressed(x,y,btn)
	h,k=circle_hovered[2],circle_hovered[3]

	if circle_hovered and (x-h)*(x-h) + (y-k)*(y-k) <= CIRCLE_RADIUS*CIRCLE_RADIUS then
		if btn==1 then
			love.system.setClipboardText(circle_hovered[1])
			sound:play()
			print("Copied '"..circle_hovered[1].."' to clipboard")
		else
			love.system.setClipboardText(table.concat(colors[circle_hovered[1]],","))
			sound:play()
			print("Copied '"..table.concat(colors[circle_hovered[1]],",").."' to clipboard")			
		end
	end
end
