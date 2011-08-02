module Nario::Material
  class Goal < Material
    def initialize(x, y, img=SDL::Surface.load("nario/image/goal.bmp"))
      super(x, y, img.w, img.h, img)
    end

    def leftside_range
      {:x_range => (@x+@w-@w/6)..(@x+@w), :y_range => (@y+@h/6)..(@y+@h-@h/6), :event => ("collide_#{extract_class_name(self)}_left".to_sym)}
    end
  end
end
