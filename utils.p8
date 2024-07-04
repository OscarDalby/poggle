-- utils


-- config
local CONFIG = {
	SCREEN_WIDTH = 127,
	SCREEN_HEIGHT = 127,
	ROOM_WIDTH = 16,
	ROOM_HEIGHT = 16,
	ROOMS_PER_ROW = 8,
	TOTAL_ROOMS = 32,
}

-- quotes all args and prints to host console
-- usage:
--   log("handles nils", many_vars, {tables=1, work=11, too=111})
function log(...)
	printh(qq(...))
	return ...
end

-- quotes all arguments into a string
-- usage:
--   ?qq("p.x=",x,"p.y=",y)
function qq(...)
	local args = pack(...)
	local s = ""
	for i = 1, args.n do
		s ..= quote(args[i]) .. " "
	end
	return s
end

-- quote a single thing
-- like tostr() but for tables
-- don't call this directly; call log or qq instead
function quote(t, depth)
	depth = depth or 4 --avoid inf loop
	if type(t) ~= "table" or depth <= 0 then
		return tostr(t)
	end

	local s = "{"
	for k, v in pairs(t) do
		s ..= tostr(k) .. "=" .. quote(v, depth - 1) .. ","
	end
	return s .. "}"
end

-- like sprintf (from c)
-- usage:
--   ?qf("%/% is %%",3,8,3/8*100,"%")
function qf(fmt, ...)
	local parts, args = split(fmt, "%"), pack(...)
	local str = deli(parts, 1)
	for ix, pt in ipairs(parts) do
		str ..= quote(args[ix]) .. pt
	end
	if args.n ~= #parts then
		-- uh oh! mismatched arg count
		str ..= "(extraqf:" .. (args.n - #parts) .. ")"
	end
	return str
end
local function pqf(...)
	printh(qf(...))
end

-- log end

local MAP = {}

for room_number = 0, CONFIG.TOTAL_ROOMS - 1 do
	local row_number = room_number // CONFIG.ROOMS_PER_ROW
	local column_number = room_number % CONFIG.ROOMS_PER_ROW
	local start_x = column_number * CONFIG.ROOM_WIDTH
	local end_x = start_x + CONFIG.ROOM_WIDTH - 1
	local start_y = row_number * CONFIG.ROOM_HEIGHT
	local end_y = start_y + CONFIG.ROOM_HEIGHT - 1
	MAP["ROOM_" .. room_number] = { START_X = start_x, END_X = end_x, START_Y = start_y, END_Y = end_y }
end

-- utils

-- physics utils
local function point_in_rect(x, y, left, top, right, bottom)
	return top < y and y < bottom and left < x and x < right
end

local function lines_overlapping(min1, max1, min2, max2)
	return max1 >= min2 and max2 >= min1
end

local function rects_overlapping(t1, r1, b1, l1, t2, r2, b2, l2)
	return lines_overlapping(l1, r1, l2, r2) and lines_overlapping(t1, b1, t2, b2)
end

local fbget = function(tile_index, flag)
	flag = flag or (-1)
	if flag > -1 then
		
		return fget(tile_index) == flag
	else
		return fget(tile_index)
	end
end

local function save_game()
    dset(0, entities[1].x)
    dset(1, entities[1].y)
end

local function draw_screen_boundary(x, y)
    local x2 = x + CONFIG.SCREEN_WIDTH
    local y2 = y + CONFIG.SCREEN_HEIGHT
    rect(x, y, x2, y2, 7)
end

local function collide_map(obj, dir, flag)
	local x = obj.x
	local y = obj.y
	local w = obj.w
	local h = obj.h
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0

	-- notes on collision boxes
	-- if the player speed increases, the hitbox should
	-- move further infront of them

	if dir == "up" then
		x1 = x + 2
		y1 = y - 1
		x2 = x + w - 3
		y2 = y
	elseif dir == "right" then
		x1 = x + w - 1
		y1 = y
		x2 = x + w
		y2 = y + h - 1
	elseif dir == "down" then
		x1 = x + 2
		y1 = y + h
		x2 = x + w - 3
		y2 = y + h
	elseif dir == "left" then
		x1 = x - 1
		y1 = y
		x2 = x
		y2 = y + h - 1
	elseif dir == "" then
		x1 = x + 2
		y1 = y - 1
		x2 = x + w - 3
		y2 = y + h
	elseif dir == "pickup" then
		x1 = x
		y1 = y
		x2 = x + w
		y2 = y + h + 4
	end

	--convert pixels to tiles
	x1 /= 8
	y1 /= 8
	x2 /= 8
	y2 /= 8
	


	if fbget(mget(x1, y1), flag) or fbget(mget(x1, y2), flag) or fbget(mget(x2, y1), flag) or fbget(mget(x2, y2), flag) then
		return true
	end
end

local function limit_num(num, max)
	return mid(-max, num, max)
end

-- misc utils

local function at_bottom_of_screen(object)
	if object.y == CONFIG.SCREEN_HEIGHT then
		return true
	end
	return false
end
