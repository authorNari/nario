module Nario::Scene
  class Title < Scene
    def start
    end

    def act(input)
      deploy
      return @success if input.ok
    end

    def render(screen)
      @backgrounds.each{|bg| bg.put_screen(screen) }
    end
  end
end
