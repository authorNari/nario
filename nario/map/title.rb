module Nario
  module Map
    TITLE = lambda {|s|
      background Material::BackGround.new_single_image(0, 0, SDL::Surface.load("nario/image/title.bmp"))
    }
  end
end
