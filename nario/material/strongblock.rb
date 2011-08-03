module Nario::Material
  class StrongBlock < Material
    def initialize(x, y, img=SDL::Surface.load("nario/image/strong_block.bmp"))
      super(x, y, img.w, img.h, img)
    end
  end
end
