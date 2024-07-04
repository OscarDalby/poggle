pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include utils.p8


-- state
local game_running = false
local start_menu = true
local paused = false
local timer = 0
local cam={x=0,y=0}


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


local core = {
    cursor_pos = 1,
    pause_options={"resume", "save", "reload last save", "quit"},
    pause_option_function_mapping={"resume", "save", "reload", "quit"},
    pause_option_map={},
    pause_timeout=2,
    save=function(self)
        log("saved")
        dset(0, player)
    end,
    load=function(self)
        log("loaded")
        player = dget(0)
    end,
    restart=function(self)
        log("restart")
        load("main.p8")
        run()
    end,
    reload=function(self)
        log("reload")
        self:load()
        self:restart()
    end,
    pause=function(self)
        log("paused")
        paused = true
        game_running = false
    end,
    quit=function(self)
        log("quit")
    end,
    resume=function(self)
        log("resumed")
        start_menu = false
        paused = false
        game_running = true
    end,
    draw=function(self)
        if start_menu then
            local text = "press any button to start"
            spr(64,60,70)
            print(text, cam.x+(CONFIG.SCREEN_WIDTH - #text * 4) / 2, 40, 10)
        elseif paused then -- pause menu 
            local text_x = cam.x+(CONFIG.SCREEN_WIDTH - 64) / 2
            local step_y = 10
            print(">",  text_x - 8, 40+(self.cursor_pos*10), 7)
            local i = 1
            for option in all(self.pause_options) do
                print(option, text_x, 40+(i*10), 10)
                i+=1
            end
            
        end
    end,
    update=function(self)
        self.pause_timeout-=1
        if btnp(2,1) and (not paused)  then
                self:pause()
                self.pause_timeout=2
        end
        if btnp(2,1) and paused and not (self.pause_timeout>0) then
            local function_name = self.pause_option_function_mapping[self.cursor_pos]
            local function_to_call = self[function_name]
            function_to_call(self)
            -- self:resume()
        end

        if paused and btnp(2) then
            if self.cursor_pos > 1 then
                self.cursor_pos -=1
            end
        end
        if paused and btnp(3) then
            if self.cursor_pos < #self.pause_options then
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

local board={
    tiles={},
    current_tiles={},
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
end

function _update()
    core:update()
    if btnp(0) or btnp(1) or btnp(2) or btnp(3) or btnp(4) or btnp(5) then
        if start_menu then
            core:resume()
        end
    end

    if start_menu or paused then
        return
    end


    board:update()
    camera_update()
    
end

function _draw()
  cls()
  draw_screen_boundary(cam.x, cam.y)


  if start_menu or paused then
    core:draw()
  elseif game_running then
    board:draw()
    draw_map()
  end

  if start_menu or paused then
    -- dont draw ui
  else
    ui:draw()
  end

end

