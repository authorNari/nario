module Nario
  module Life
    class Nario < Life
      DASH_MAX_DASH_SPEED = 5
      B_DASH_MAX_DASH_SPEED = 9

      #limit break
      #B_DASH_MAX_DASH_SPEED = 100

      def initialize(x, y)
        im = SDL::Surface.load("nario/image/chibi_nario.bmp")
        super(x, y, clean_bg(im.copy_rect(0, 0, 50, 50)))
        @slip_right_img = clean_bg(im.copy_rect(200, 0, 50, 50))
        @slip_left_img = clean_bg(im.copy_rect(200, 51, 50, 50))
        @jump_right_img = clean_bg(im.copy_rect(250, 0, 50, 50))
        @jump_left_img = clean_bg(im.copy_rect(250, 51, 50, 50))
        @def_right_img = clean_bg(im.copy_rect(0, 0, 50, 50))
        @def_left_img = clean_bg(im.copy_rect(0, 51, 50, 50))
        @animate_right = [im.copy_rect(50, 0, 50, 50), im.copy_rect(100, 0, 50, 50), im.copy_rect(150, 0, 50, 50), 0]
        @animate_right.map{|i| clean_bg(i)  unless i == 0}
        @animate_left = [im.copy_rect(50, 51, 50, 50), im.copy_rect(100, 51, 50, 50), im.copy_rect(150, 51, 50, 50), 0]
        @animate_left.map{|i| clean_bg(i)  unless i == 0}
        @dead_img = clean_bg(im.copy_rect(300, 0, 50, 50))
        @goal_img = clean_bg(im.copy_rect(300, 51, 50, 50))
        @dash_speed = 0
        @is_controll = true
        @is_goal = false
        @is_jumpping = false
        @hp = 100
        @font = SDL::TTF.open('nario/fonts/VeraMoBd.ttf', 30)
      end

      def put_screen(screen)
        super
        @font.draw_solid_utf8(screen, "Time", 2, 2, *Color::BLACK)
        max = Scene::SCREEN_WIDTH-80-10
        hp_width = (max.to_f * 0.01 * @hp).to_i
        screen.fill_rect(80, 10, hp_width, 20, Color::BLACK)
      end

      # collision event
      def collide_can_right(k) @movie_event = :movie_die end
      alias collide_can_left collide_can_right
      alias collide_can_foot collide_can_right
      def collide_can_head(k)  force_jump end
      alias collide_dustbin_right collide_can_right
      alias collide_dustbin_left collide_can_left
      alias collide_dustbin_foot collide_can_foot
      alias collide_dustbin_head collide_can_head
      def collide_carapace_right(c) @movie_event = :movie_die if c.violence?; c.x-=10; end
      def collide_carapace_left(c) @movie_event = :movie_die if c.violence?; c.x+=10; end
      def collide_weakblock_foot(w) force_fall(w) end
      alias collide_itembox_foot collide_weakblock_foot
      def collide_goal_right(c) @is_goal = true end
      alias collide_goal_left collide_goal_right
      alias collide_goal_head collide_goal_right
      alias collide_goal_foot collide_goal_right
      def collide_pole_left(p) @movie_event = :movie_goal unless @movie_event; @x = p.x-40; end

      # collision range
      def foot_range
        {:x_range => (@x+@w/6)..(@x+@w-@w/6), :y_range => (@y+@h-@h/6)..(@y+@h), :event => :collide_nario_foot}
      end

      # relation controller
      def b_dash_right
        dash(1, @animate_right, ((@frame % 10).zero? and @dash_speed < B_DASH_MAX_DASH_SPEED))
      end

      def b_dash_left
        dash(-1, @animate_left, ((@frame % 10).zero? and @dash_speed > -(B_DASH_MAX_DASH_SPEED)))
      end

      def dash_right
        # map deploy reserch
        # puts "x:#{@x} y:#{@y}"
        dash(1, @animate_right, ((@frame % 10).zero? and @dash_speed < DASH_MAX_DASH_SPEED))
      end

      def dash_left
        dash(-1, @animate_left, ((@frame % 10).zero? and @dash_speed > -(DASH_MAX_DASH_SPEED)))
      end

      def jump
        unless @is_fly or @jump_lock
          frame_reset
          @is_fly = true
          @jump_lock = true
          change_img(@jump_left_img) if @direction[:left]
          change_img(@jump_right_img) if @direction[:right]
          agravity
        else
          @fall_speed -= 2 if (@frame % 4).zero? and @fall_speed < 0
        end
      end

      def goal?
        @is_goal
      end

      def controll?
        @is_controll
      end

      def jump_unlock
        @jump_lock = false if !@is_fly
      end

      def free
        return dash_stop
      end

      def dash_stop
        x_move(@dash_speed)
        return if (@frame % get_dash_frame(@dash_speed)).nonzero?

        if @dash_speed > 0
          @dash_speed -= 1
          animate_dash(@animate_right, @dash_speed)
        elsif @dash_speed < 0
          @dash_speed += 1
          animate_dash(@animate_left, @dash_speed)
        else
          change_img(@def_left_img) if @direction[:left] and !@is_fly
          change_img(@def_right_img) if @direction[:right] and !@is_fly
        end
      end

      def movie_goal
        @frame = 1 if @is_controll
        if (@frame % 80).zero?
          @movie_event = :movie_dash_goal
        end
        force_notfall
        @is_controll = false
        change_img(@goal_img)
        y_move(5)
      end

      def movie_dash_goal
        @dash_speed = DASH_MAX_DASH_SPEED
        dash(1, @animate_right, @dash_speed)
      end

      def movie_die
        unless @is_dead
          @frame = 1
          @is_dead = true
        end
        force_notfall
        if (@frame % 40).zero?
          3.times{ force_jump }
          movie_end
        end
        change_img(@dead_img)
      end

      def force_jump
        @is_fly = false
        jump_unlock
        jump
      end

      def force_fall(w)
        @fall_speed = -1
        @y = w.y + w.h + 5
      end

      def state
        "x=#{@x} y=#{@y} dash_speed=#{@dash_speed} fall_speed=#{@fall_speed}  fly? #{@is_fly}"
      end

      def damage(d)
        @hp -= d if @hp > 0
        @hp = 0 if @hp < 0
        @movie_event = :movie_die if @hp == 0
      end
    end
  end
end
