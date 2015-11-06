local lg = love.graphics
local debug = false
local player = {
  pos = {x=450, y=340, z=0}, -- z is 0-255
  size = 1,
  speed = 150,
  img = nil,
  imgsize = {x=0,y=0},
  hunger = 200
}
local icons = {}

local bg, canvas;

local objects = {
  {ico = "I_Bone.png", h=0, x=480, y=140},
  {ico = "I_C_Banana.png", h=50, x=117, y=145},
  {ico = "I_C_Strawberry.png",h=20, x=385, y=116},
  {ico = "I_C_Watermellon.png", h=40, x=203, y=118},
  {ico = "P_Red01.png", h=100, x=583, y=109},

  {ico = "I_Bone.png", h=0, x=686, y=171},
  {ico = "I_C_Banana.png", h=50, x=760, y=313},
  {ico = "I_C_Strawberry.png",h=20, x=715, y=339},
  {ico = "I_C_Watermellon.png", h=40, x=667, y=318},
  {ico = "P_Red01.png", h=100, x=653, y=368},

  {ico = "I_C_Banana.png", h=50, x=504, y=335},
  {ico = "I_C_Strawberry.png",h=20, x=472, y=338},
  {ico = "I_C_Watermellon.png", h=40, x=205, y=402},

  {ico = "I_Bone.png", h=0, x=676, y=536},
  {ico = "I_C_Banana.png", h=50, x=482, y=438},
  {ico = "I_C_Strawberry.png",h=20, x=270, y=404},
  {ico = "I_C_Watermellon.png", h=40, x=22, y=384},
  {ico = "P_Red01.png", h=200, x=223, y=347},


}

function love.load()
   bg = {
     img = lg.newImage("img/bg/bg.jpg"),
     walls = lg.newImage("img/bg/walls.png"),
     depth = lg.newImage("img/bg/depth.png"),
   }
   bg.scale = {
     x = lg:getWidth() / bg.img:getWidth(),
     y = lg:getHeight() / bg.img:getHeight()
   }

   player.img = lg.newImage("img/player.png")
   player.imgsize = {x=player.img:getWidth(),y=player.img:getHeight()}

   canvas = lg.newCanvas(lg:getWidth(), lg:getHeight())
   lg.setCanvas(canvas)
   canvas:clear()
   --love.graphics.setBlendMode('alpha')

   lg.setColor(255, 255, 255)
   lg.draw(bg.img, 0, 0, 0, bg.scale.x, bg.scale.y)
   --lg.draw(bg.depth, 0, 0, 0, bg.scale.x, bg.scale.y)
   --lg.setColor(255, 255, 255, 80)
   --lg.draw(bg.mask, 0, 0, 0, bg.scale.x, bg.scale.y)

   lg.setCanvas()

   for _, file in ipairs(love.filesystem.getDirectoryItems("img/ico")) do
     icons[file] = lg.newImage("img/ico/"..file)
     print(file, "loaded")
   end

end


local drawCross = function(x,y)
  local w,h = 10,4
  lg.setColor(255,0,0)
  lg.line(x-w, y, x+w, y)
  lg.line(x, y-h, x, y+h)
  lg.print(math.floor(x)..","..math.floor(y), x+5, y+5)
end



local getPixel = function(img,x,y)
  return img:getData():getPixel(x/bg.scale.x, y/bg.scale.y)
end

local getPixelAlpha = function(img,x,y)
  local _,_,_,a = getPixel(img,x,y)
  return a
end
local canWalkTo = function(to, tolx, toly)
  if getPixelAlpha(bg.walls, to.x, to.y) < 50 then return true, to
  elseif tolx>0 and getPixelAlpha(bg.walls, to.x + tolx, to.y) < 50 then return true, {x=to.x + tolx, y=to.y}
  elseif tolx>0 and getPixelAlpha(bg.walls, to.x - tolx, to.y) < 50 then return true, {x=to.x - tolx, y=to.y}
  elseif toly>0 and getPixelAlpha(bg.walls, to.x, to.y + toly) < 50 then return true, {x=to.x, y=to.y + toly}
  elseif toly>0 and getPixelAlpha(bg.walls, to.x, to.y - toly) < 50 then return true, {x=to.x, y=to.y - toly}
  else return false end
end

local addPos = function(orig, movex, movey)
  return {x = orig.x+movex, y = orig.y+movey}
end

function love.update(dt)

  player.hunger = player.hunger + 6*dt

   if love.keyboard.isDown("right") then
      local canWalk, to = canWalkTo(addPos(player.pos, player.speed * dt, 0), 0, 2)
      if canWalk then player.pos = to end

   elseif love.keyboard.isDown("left") then
      local canWalk, to = canWalkTo(addPos(player.pos, -player.speed * dt, 0), 0, 2)
      if canWalk then player.pos = to end
   end

   if love.keyboard.isDown("down") then
      local canWalk, to = canWalkTo(addPos(player.pos, 0, player.speed * dt), 2, 0)
      if canWalk then player.pos = to end

   elseif love.keyboard.isDown("up") then
      local canWalk, to = canWalkTo(addPos(player.pos, 0, -player.speed * dt), 2, 0)
      if canWalk then player.pos = to end

   end

   local p = player.pos

   for _,o in ipairs(objects) do

      o.scale = o.y/255 * 0.5 + 0.2

      local s=o.scale*34*0.5
      if (not o.disabled) and math.abs(p.x-o.x)<s and math.abs(p.y-o.y)<s then
        print ("eat", p.x,p.y,o.x,o.y, s,o.scale)
        o.disabled = true
        player.hunger = player.hunger - o.h
      end

   end

   player.pos.z = (255 * (lg:getHeight() - player.pos.y)) / lg:getHeight()
   -- TODO finetune
   player.size = (player.pos.y / 300 + 0.2) *0.7
   player.speed = player.pos.y / 4 + 0

end


function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   if key == "d" then
      debug = not debug
   end
end

function love.mousepressed(x, y, button)
  print ("click", x, y, button)
  if not debug then return end

  if button == "l" then -- this is the lowercase letter L, not a one (1)
     player.pos.x=x
     player.pos.y=y
  end
     if button == "r" then
       objects[#objects+1] = {ico = "I_C_Banana.png", x=x, y=y}
     end
end

local drawIco = function(o)
     if debug then
       drawCross(o.x,o.y)
       lg.rectangle("line", o.x-34*o.scale*0.5, o.y-34*o.scale*0.5, 34*o.scale,34*o.scale)
     end
     lg.draw(icons[o.ico], o.x-34*o.scale*0.5, o.y-34*o.scale*0.5, 0, o.scale, o.scale)
end
-------------------


function love.draw()
   lg.setColor(255, 255, 255)
   lg.draw(canvas)

   for _,o in ipairs(objects) do
     if not o.disabled then drawIco(o) end
   end

  -- player
  local depthTolerance = 2

  for x=0, (player.imgsize.x-1)*player.size do
    for y=0, (player.imgsize.y-1)*player.size do

      local bgx = math.floor(x + player.pos.x-player.imgsize.x*player.size/2) + 0.5
      local bgy = math.floor(y + player.pos.y-player.imgsize.y*player.size) + 0.5
      local bgPixel,_,_,alpha = getPixel(bg.depth, bgx, bgy)
      if alpha == 0 or bgPixel + depthTolerance > player.pos.z then
        lg.setColor(player.img:getData():getPixel(x/player.size, y/player.size))
        lg.point(bgx,bgy)
      end
    end
  end

  if debug then drawCross(player.pos.x, player.pos.y) end

  lg.setColor(200, 100, 100)
  lg.rectangle("fill", 20,20,math.max(0,player.hunger), 25)

  lg.setColor(255, 255, 255)
  lg.print("Hunger: "..math.max(0,math.floor(player.hunger)), 32, 26)

  if(debug) then
   lg.setColor(255, 255, 255)
   lg.print("FPS: "..tostring(love.timer.getFPS( )), 10, 40)
 end
end
