pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

-- utils

-- config
local CONFIG = {
	SCREEN_WIDTH = 127,
	SCREEN_HEIGHT = 127
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

local function draw_screen_boundary(x, y)
    local x2 = x + CONFIG.SCREEN_WIDTH
    local y2 = y + CONFIG.SCREEN_HEIGHT
    rect(x, y, x2, y2, 7)
end

local function limit_num(num, max)
	return mid(-max, num, max)
end

local function at_bottom_of_screen(object)
	if object.y == CONFIG.SCREEN_HEIGHT then
		return true
	end
	return false
end
