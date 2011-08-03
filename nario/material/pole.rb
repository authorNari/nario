module Nario::Material
  class Pole < Material
    def initialize(x, y)
      img = clean_bg(SDL::Surface.load("nario/image/pole.bmp"))
      super(x, y, img.w, img.h, img)
      @flag = BackGround.new_single_image(x-37, y+25, SDL::Surface.load("nario/image/flag.bmp"))
    end

    def collide_nario_right(m); @movie_event = :movie_flag_down; end

    def movie_flag_down
      return movie_end if (@flag.y+@flag.h) > (@y + @h)
      @flag.y_move(5)
    end

    def y_move(y)
      @y += y
      @flag.y += y
    end

    def x_move(x)
      @x += x
      @flag.x += x
    end

    def put_screen(screen)
      screen.put(@img, @x, @y)
      screen.put(@flag.img, @flag.x, @flag.y)
    end
  end
end
