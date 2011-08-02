module Nario::Material
  class Pipe < Material
    def initialize(x, y, img=SDL::Surface.load("nario/image/pipe.bmp"))
      clean_bg(img)
      super(x, y, img.w, img.h, img)
    end
  end
end
