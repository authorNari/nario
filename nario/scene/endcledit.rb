module Nario
  module Scene
    class EndCledit < Scene
      def initialize(&block)
        super
        @font = SDL::TTF.open('nario/fonts/VeraMoBd.ttf', 60)
        @gc_ave = nil
      end

      def act(input)
        exit(0) if input.exit
        return @success if input.ok
      end

      def render(screen)
        @gc_ave ||= GC::Profiler.total_time / GC.count * 100
        base = 100
        screen.fill_rect(0, 0, SCREEN_WIDTH, SCREEN_HIGHT, Color::WHITE)
        @font.draw_solid_utf8(screen, "Congrats! GAME CLEAR!!",
                              10, base, *Color::BLACK)
        @font.draw_solid_utf8(screen, "GC ave: #{@gc_ave}",
                              10, base+80, *Color::BLACK)
        @font.draw_solid_utf8(screen, "ESC: end",
                              10, base+80*3, *Color::BLACK)
        @font.draw_solid_utf8(screen, "Enter: continue",
                              10, base+80*4, *Color::BLACK)
        screen.update_rect(0, 0, SCREEN_WIDTH, SCREEN_HIGHT)
        # sleep 20 # for demo (sleep for ruby process)
      end
    end
  end
end
