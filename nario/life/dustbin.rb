module Nario::Life
  class Dustbin < Enemy
    DASH_MAX_DASH_SPEED = 2
    JUMP_MAX_SPEED = -15

    def initialize(x, y)
      im = SDL::Surface.load("nario/image/dustbin.bmp")
      super(x, y, clean_bg(im.copy_rect(0, 0, 50, 69)))
      @animate_right = [im.copy_rect(0, 70, 50, 69), im.copy_rect(50, 70, 50, 69), 0]
      @animate_right.map{|i| clean_bg(i)  unless i == 0}
      @animate_left = [im.copy_rect(0, 0, 50, 69), im.copy_rect(50, 0, 50, 69), 0]
      @animate_left.map{|i| clean_bg(i)  unless i == 0}
      @dash_speed = DASH_MAX_DASH_SPEED
      @direction = {:right => false, :left => true}
    end

    def action
      send(@movie_event) if @movie_event
      if @is_dead
        @is_garbage = true if (@frame % 40).zero?
        return
      end
      walk_left if @direction[:left]
      walk_right if @direction[:right]
    end

    # collision event
    def collide_nario_foot(nario)
      @now_scene.in(:enemy, Carapace.new(@x, @y+20))
      @img = nil
      @is_dead = true
    end

    def collide_floor_head(floor)
      walk_right if ((floor.x)..(floor.x + 3)).include? @x
      walk_left if ((floor.x + floor.w - 3)..(floor.x + floor.w)).include?((@x+@w))
      stand_up(floor)
    end

    def collide_weakblock_head(w)
      if w.movie_event.to_s == "bound"
        @now_scene.in(:enemy, Carapace.new(@x, @y+20))
        @img = nil
        @is_dead = true
      end
      stand_up(w)
    end
    alias collide_itembox_head collide_weakblock_head

    private
    def get_dash_frame(dash_speed)
      step_rate = 6
    end

    def walk_left
      @dash_speed = -DASH_MAX_DASH_SPEED
      dash(-1, @animate_left, false)
    end

    def walk_right
      @dash_speed = DASH_MAX_DASH_SPEED
      dash(1, @animate_right, false)
    end
  end
end
