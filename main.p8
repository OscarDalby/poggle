pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include utils.p8


-- state
local game_running = false
local start_menu = true
local timer_counting = true
local timer_start = (5*30)+10
local timer = timer_start
local timer_announced=false
local cam={x=0,y=0}
local current_tileset
local tile_config={}


local tiles_4x4_classic = {
    {1, 1, 5, 5, 7, 14},
    {5, 12, 18, 20, 20, 25},
    {1, 15, 15, 20, 20, 23},
    {1, 2, 2, 10, 15, 15},
    {5, 8, 18, 20, 22, 23},
    {3, 9, 13, 15, 20, 21},
    {4, 9, 19, 20, 20, 25},
    {5, 9, 15, 19, 19, 20},
    {4, 5, 12, 18, 22, 25},
    {1, 3, 8, 15, 16, 19},
    {8, 9, 13, 14, 17, 21},
    {5, 5, 9, 14, 19, 21},
    {5, 5, 7, 8, 14, 23},
    {1, 6, 6, 11, 16, 19},
    {8, 12, 14, 14, 18, 26},
    {4, 5, 9, 12, 18, 24}
}
local tiles_4x4_new = {
    {1, 1, 3, 9, 15, 20},
    {1, 8, 13, 15, 18, 19},
    {5, 7, 11, 12, 21, 25},
    {1, 2, 9, 12, 20, 25},
    {1, 3, 4, 5, 13, 16},
    {5, 7, 9, 14, 20, 22},
    {7, 9, 12, 18, 21, 23},
    {5, 12, 16, 19, 20, 21},
    {4, 5, 14, 15, 19, 23},
    {1, 3, 5, 12, 18, 19},
    {1, 2, 10, 13, 15, 17},
    {5, 5, 6, 8, 9, 25},
    {5, 8, 9, 14, 16, 19},
    {4, 11, 14, 15, 20, 21},
    {1, 4, 5, 14, 22, 26},
    {2, 9, 6, 15, 18, 24}
}

board={
    tiles={},
    rows=4,
    cols=4,
    cube_spr=1,
    board_offset_x=30,
    board_offset_y=14,
    shake=function(self)
        -- reset states
        timer=timer_start
        timer_announced=false
        tile_config={}
        
        shuffle_arr(current_tileset)
        for cube in all(current_tileset) do
            local new_cube_val=cube[flr(rnd(5) + 1)]
            add(tile_config, new_cube_val)
        end
    end,
    init=function(self)
        current_tileset=tiles_4x4_new
        self:shake()
    end,
    update=function(self)
    end,
    draw_letters=function(self)
        local index=1
        local color=0
        local shadow_color=6
        for j = 1, self.rows do
            for i = 1, self.cols do
                local tile = tile_config[index]
                spr(1,i*12 - 48+self.board_offset_x,j*12+self.board_offset_y,7,1,1)
                print(alphabet(tile),(i*12)+2+self.board_offset_x,(j*12)+2+self.board_offset_y, shadow_color)
                print(alphabet(tile),(i*12)+3+self.board_offset_x,(j*12)+1+self.board_offset_y, color)
                index = index + 1
            end
        end
    end,
    draw_board=function(self)
        -- 17,18,19
        -- 33,34,35
        -- 49,50,51
        local start_x=10+self.board_offset_x
        local start_y=10+self.board_offset_y

        -- row 1
        spr(17,start_x,start_y,1,1)
        spr(18,start_x+8,start_y,1,1)
        spr(18,start_x+16,start_y,1,1)
        spr(18,start_x+24,start_y,1,1)
        spr(18,start_x+32,start_y,1,1)
        spr(19,start_x+40,start_y,1,1)
        -- row 2
        spr(33,start_x,start_y+8,1,1)
        spr(34,start_x+8,start_y+8,1,1)
        spr(34,start_x+16,start_y+8,1,1)
        spr(34,start_x+24,start_y+8,1,1)
        spr(34,start_x+32,start_y+8,1,1)
        spr(35,start_x+40,start_y+8,1,1)
        -- row 3
        spr(33,start_x,start_y+16,1,1)
        spr(34,start_x+8,start_y+16,1,1)
        spr(34,start_x+16,start_y+16,1,1)
        spr(34,start_x+24,start_y+16,1,1)
        spr(34,start_x+32,start_y+16,1,1)
        spr(35,start_x+40,start_y+16,1,1)
        -- row 4
        spr(33,start_x,start_y+24,1,1)
        spr(34,start_x+8,start_y+24,1,1)
        spr(34,start_x+16,start_y+24,1,1)
        spr(34,start_x+24,start_y+24,1,1)
        spr(34,start_x+32,start_y+24,1,1)
        spr(35,start_x+40,start_y+24,1,1)
        -- row 5
        spr(33,start_x,start_y+32,1,1)
        spr(34,start_x+8,start_y+32,1,1)
        spr(34,start_x+16,start_y+32,1,1)
        spr(34,start_x+24,start_y+32,1,1)
        spr(34,start_x+32,start_y+32,1,1)
        spr(35,start_x+40,start_y+32,1,1)
        -- row 6
        spr(49,start_x,start_y+40,1,1)
        spr(50,start_x+8,start_y+40,1,1)
        spr(50,start_x+16,start_y+40,1,1)
        spr(50,start_x+24,start_y+40,1,1)
        spr(50,start_x+32,start_y+40,1,1)
        spr(51,start_x+40,start_y+40,1,1)


    end,
    draw=function(self)
        self:draw_board()
        self:draw_letters()
    end
    
}


local core = {
    cursor_pos = 1,
    action_options={"shake","pause timer", "swap tile era", "change board size", "restart"},
    action_option_function_mapping={"shake","start_pause_timer", "change_tileset", "change_board_size", "restart"},
    action_option_map={},
    action_timeout=2,
    shake=function(self)
        board:shake()
    end,
    start_pause_timer=function(self)
        if timer_counting then
            timer_counting=false
            self.action_options[2]="resume timer"
        else
            timer_counting=true
            self.action_options[2]="pause timer"
        end
    end,
    change_tileset=function(self)
    end,
    change_board_size=function(self)
    end,
    restart=function(self)
        timer=(90*30)+10
        board:shake()
    end,
    resume=function(self)
        log("resumed")
        start_menu = false
        game_running = true
    end,
    draw_options=function(self)
        local text_x = cam.x+(CONFIG.SCREEN_WIDTH - 64) / 2
        local start_y=68
        local step_y = 10
        print(">",  text_x - 8, start_y+(self.cursor_pos*10), 7)
        local i = 1
        for option in all(self.action_options) do
            print(option, text_x, start_y+(i*10), 10)
            i+=1
        end
    end,
    draw_timer=function(self)
        local time_remaining_text = "time remaining:"
        local start_x=28
        local start_y=12
        local color=7
        print(time_remaining_text, start_x, start_y, color)
        print(tostr(flr(timer/30)), start_x+2+(4*#time_remaining_text), start_y, color)
    end,
    draw=function(self)
        if start_menu then
            local text = "press any button to start"
            spr(64,60,70)
            print(text, cam.x+(CONFIG.SCREEN_WIDTH - #text * 4) / 2, 40, 10)
        else
            self:draw_options()
            self:draw_timer()
        end
    end,
    update=function(self)
        if start_menu then return end

        if timer_counting and timer > 0 then
            timer-=1
        elseif timer < 1 and not timer_announced then
            timer_announced=true
            sfx(0)
            sfx(0)
            sfx(0)
            sfx(0)
            log("time finished!")
        end

        if btnp(4) then
            local function_name = self.action_option_function_mapping[self.cursor_pos]
            local function_to_call = self[function_name]
            function_to_call(self)
        end

        if btnp(2) then
            if self.cursor_pos > 1 then
                self.cursor_pos -=1
            end
        end

        if btnp(3) then
            if self.cursor_pos < #self.action_options then
                self.cursor_pos +=1
            end
        end

    end
}
  
local ui = {
  init=function(self)
  end,
  update=function(self)
  end,
  draw=function(self)
  end
}







function draw_map()
    map(0,0)
end

function camera_update()
    cam.x = 0
    cam.y = 0
    camera(cam.x,cam.y)
end

function _init()
    log("PROGRAM START")
    cartdata("oscardalby_game_v0")
    board:init()
end

function _update()
    core:update()
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(4) or btnp(5) then
        if start_menu then
            core:resume()
        end
    end

    if start_menu or actiond then
        return
    end


    board:update()
    camera_update()
    
end

function _draw()
  cls()
  draw_screen_boundary(cam.x, cam.y)


  core:draw()
    
  if game_running then
    
    board:draw()
    draw_map()
  end

  if start_menu or actiond then
    -- dont draw ui
  else
    ui:draw()
  end

end

__gfx__
00000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000677777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000aa99999999999999999999aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a99999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000a9999999999999999999999a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaaaaaaaaaaaaaaaaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000002750037100471006720087200a7200d7200e7200f7301273016730197301b7301c7401e7401f7402074021740217401f7401e7601d7601c7601c7601c7601d7601f7601f77020770207701e7701d770
