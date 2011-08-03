require_relative 'factor'

module Nario::Life
  class Life < Nario::Factor
    attr_accessor :frame, :direction

    def initialize(x, y, img)
      super(x, y, img.w, img.h, img)
      @slip_right_img = nil
      @slip_left_img = nil
      @jump_right_img = nil
      @jump_left_img = nil
      @animate_right = nil
      @animate_left = nil
      @dash_speed = 0
      @jump_speed = 0
      @fall_speed = 0
      @is_fly = false
      @direction = {:right => true, :left => false}
    end


    def put_screen(screen)
      screen.put(@img, @x, @y) if @img
    end

    def dash(move_rate, animate_img, is_sp_update)
      return if slip(move_rate)
      set_direction(move_rate)
      @dash_speed = move_rate if @dash_speed.zero?
      @dash_speed += move_rate if is_sp_update
      animate_dash(animate_img, @dash_speed)
      x_move(@dash_speed)
    end

    def jump
      unless @is_fly
        @is_fly = true
        change_img(@jump_left_img) if @direction[:left] and @jump_left_img
        change_img(@jump_right_img) if @direction[:right] and @jump_right_img
        agravity
      else
        @fall_speed -= 2 if (@frame % 4).zero? and @fall_speed < 0
      end
    end

    def gravity
      fall
    end

    def agravity
        @fall_speed = -15
        y_move(-2)
    end

    def frame_reset
      @frame = 0
    end

    def force_notfall
      @fall_speed = 0
    end

    def stand_up(floor)
      @y = floor.y - @h - 1
      @fall_speed = 0
      @is_fly = false
    end

    def fall
      @is_fly = true if @fall_speed.nonzero?
      y_move(@fall_speed)
      @fall_speed += 1 if @fall_speed < 15
    end

    def state
      "x=#{@x} y=#{@y}"
    end

    def head_range
      {:x_range => (@x+@w/6)..(@x+@w-@w/6), :y_range => @y..(@y+@h/6), :event => ("collide_#{extract_class_name(self)}_head".to_sym)}
    end

    def foot_range
      {:x_range => (@x+@w/6)..(@x+@w-@w/6), :y_range => (@y+@h-@h/6)..(@y+@h), :event => ("collide_#{extract_class_name(self)}_foot".to_sym)}
    end

    def leftside_range
      {:x_range => @x..(@x+@w/6), :y_range => (@y+@h/6)..(@y+@h-@h/6), :event => ("collide_#{extract_class_name(self)}_left".to_sym)}
    end

    def rightside_range
      {:x_range => (@x+@w-@w/6)..(@x+@w), :y_range => (@y+@h/6)..(@y+@h-@h/6), :event => ("collide_#{extract_class_name(self)}_right".to_sym)}
    end

    #collision event
    def collide_floor_head(f) stand_up(f) end
    def collide_floor_left(f) @x = (f.x - @w); @dash_speed = 0; end
    def collide_floor_right(f) @x = f.x + f.w; @dash_speed = 0; end
    alias collide_weakblock_head collide_floor_head
    alias collide_weakblock_left collide_floor_left
    alias collide_weakblock_right collide_floor_right
    alias collide_itembox_head collide_floor_head
    alias collide_itembox_left collide_floor_left
    alias collide_itembox_right collide_floor_right
    alias collide_strongblock_head collide_floor_head
    alias collide_strongblock_left collide_floor_left
    alias collide_strongblock_right collide_floor_right
    alias collide_pipe_head collide_floor_head
    alias collide_pipe_left collide_floor_left
    alias collide_pipe_right collide_floor_right

    private
    # frame % ? == 0:  get ? parameter
    def get_dash_frame(dash_speed)
      step_rate = 4
      [[(4..7), 3], [(8..10), 2], [Range.new(11, 100, true), 1]].each{|i| step_rate = i.last if i.first.include? dash_speed.abs}
      step_rate
    end

    def animate_dash(m_imgs, dash_speed)
      return if @is_fly
      animate(m_imgs, get_dash_frame(dash_speed))
    end

    def slip(move_rate)
      # not turn?
      return false unless (move_rate < 0 and @dash_speed > 0) or (move_rate > 0 and @dash_speed < 0)

      #define slip_time. it's setting dash_speed
      @slip_time = @dash_speed.abs unless @slip_time and @slip_time > 0

      change_img(@slip_left_img) if @direction[:left] and !@is_fly
      change_img(@slip_right_img) if @direction[:right] and !@is_fly
      x_move(@dash_speed)
      @dash_speed = 0 if (@slip_time -= 1).zero?
      true
    end

    def set_direction(move_rate)
      return if @is_fly
      if move_rate >= 0
        @direction[:right] = true
        @direction[:left] = false
      else
        @direction[:right] = false
        @direction[:left] = true
      end
    end

    def force_jump
      @is_fly = false
      jump
    end

    def force_fall(w)
      @fall_speed = -1
      @y = w.y + w.h + 5
    end
  end

  autoload :Nario, "life/nario"
  autoload :Enemy, "life/enemy"
  autoload :Can, "life/can"
  autoload :Dustbin, "life/dustbin"
  autoload :Carapace, "life/carapace"
end
