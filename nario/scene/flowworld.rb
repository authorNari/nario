module Nario
  module Scene
    class FlowWorld < Scene
      def act(controller)
        deploy
        countup_frame
        action
        control_player(controller) unless @player.dead? or !@player.controll?
        gravity
        collision_event
        flow_right
        garbage_sweep if(@player.frame % 100).zero?
        return @miss if @player.goal?
        return @success if @player.y > SCREEN_HIGHT*2
        nil
      end

      def render(screen)
        periodic_gc_start(screen)
        @renders.each{|re| re.each{|o| o.put_screen(screen) if o.x < SCREEN_WIDTH } }
        puts "player: #{@player.state}" if $DEBUG_PLAYER_WATCH_MODE
        @player.put_screen(screen)
      end

      private
      def control_player(controller)
        @player.jump if controller.a
        @player.jump_unlock unless controller.a
        case
        when (controller.right and controller.b)
          @player.b_dash_right
        when (controller.left and controller.b)
          @player.b_dash_left
        when controller.right
          @player.dash_right
        when controller.left
          @player.dash_left
        else
          @player.free
        end
      end

      def countup_frame
        @actions.each{|a| a.countup_frame }
        @player.countup_frame
        @frame ||= 0
        @frame += 1
      end

      def action
        @actions.each{|a| a.action if a.x < SCREEN_WIDTH} unless @player.dead?
        @player.action
      end

      def gravity
        @enemys.each{|l| l.gravity }
        @player.gravity
      end

      def collision_event
        @blocks.each{|bl|
          @enemys.each{|l| l.collision_event(bl) }
          @player.collision_event(bl)
        }
        @enemys.each{|li| @player.collision_event(li) }
        @enemys.size.times{|i| @enemys.size.times{|j| @enemys[i].collision_event(@enemys[j]) if j != i}}
      end

      def garbage_sweep
        @actions.size.times{|i| sweep(@actions, i) }
        @blocks.size.times{|i| sweep(@blocks, i) }
        @enemys.size.times{|i| sweep(@enemys, i) }
        @flows.size.times{|i| sweep(@flows, i) }
        @actions.compact!
        @blocks.compact!
        @enemys.compact!
        @flows.compact!
      end

      def sweep(arry, index)
        arry[index].is_garbage = true if arry[index].y > SCREEN_HIGHT
        arry[index] = nil if arry[index].garbage?
      end

      def flow_right
        @player.x = 0 if @player.x < 0
        screen_harf = SCREEN_WIDTH/2
        shift = @player.x - screen_harf if @player.x > screen_harf
        if shift
          @flows.each{|fl| shift_material(fl, shift) }
          @player.x = screen_harf
        end
      end

      def shift_material(mt, shift)
        mt.x_move(-shift)
        mt.is_garbage = true if (mt.x + mt.w) < 0
        mt.is_garbage = true if mt.y > SCREEN_HIGHT
      end

      def periodic_gc_start(screen)
        if (@frame % 100).zero?
          t = Time.now
          screen.put(SDL::Surface.load("nario/image/gc_start.bmp"), 270, 270)
          screen.update_rect(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)
          GC.start
          t = Time.now - t
          @player.damage(t)
        end
      end
    end
  end
end
