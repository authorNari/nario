module Nario::Life
  class Carapace < Enemy
    DASH_MAX_DASH_SPEED = 11
    JUMP_MAX_SPEED = -15

    def initialize(x, y)
      im = SDL::Surface.load("nario/image/dustbin.bmp")
      super(x, y, clean_bg(im.copy_rect(100, 0, 54, 43)))
      @animate_right = [im.copy_rect(100, 0, 54, 43), 0]
      @animate_right.map{|i| clean_bg(i)  unless i == 0}
      @animate_left = [im.copy_rect(100, 0, 54, 43), 0]
      @animate_left.map{|i| clean_bg(i)  unless i == 0}
      @dead_img = clean_bg(im.copy_rect(100, 0, 54, 43))
      @dash_speed = 0
      @direction = {:right => false, :left => false}
    end

    def action
      slip_left  if @direction[:left]
      slip_right if @direction[:right]
    end

    def violence?
      return @dash_speed.nonzero?
    end

    # collision parts
    def head_range; {:x_range => (@x+@w/2-10)..(@x+@w/2+10), :y_range => (@y+10)..(@y+@h/2), :event => :collide_can_head}; end

    # collision event
    def collide_nario_foot(m); stop; end
    def collide_nario_right(m); set_direction(1); end
    def collide_nario_left(m); set_direction(-1); end
    undef collide_can_left
    undef collide_can_right
    undef collide_dustbin_left
    undef collide_dustbin_right
    def collide_carapace_left(c); collide_strongblock_left(c); end;
    def collide_carapace_right(c); collide_strongblock_right(c); end;

    def collide_weakblock_head(w)
      if w.movie_event.to_s == "bound"
        stop
        return force_jump
      end
      stand_up(w)
    end

    def clash(carapace)
      @is_dead = true
      change_img(clean_bg(@img.rotate_surface(180, [255, 255, 255])))
      frame_reset
      return force_jump
    end

    private
    def get_dash_frame(dash_speed)
      step_rate = 1000
    end

    def stop
      @dash_speed = 0
      @direction[:left] = false
      @direction[:right] = false
    end

    def slip_left
      @dash_speed = -DASH_MAX_DASH_SPEED
      dash(-1, @animate_left, false)
    end

    def slip_right
      @dash_speed = DASH_MAX_DASH_SPEED
      dash(1, @animate_right, false)
    end
  end
end
