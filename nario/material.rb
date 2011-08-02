require_relative 'factor'

module Nario::Material
  class Material < Nario::Factor
    attr_accessor :img, :fill_mtls, :color

    def initialize(x, y, w, h, img=nil, color=nil)
      @fill_mtls = nil
      @img = nil
      img.set_color_key(SDL::SRCCOLORKEY, [255, 255, 255]) if img
      super(x, y, w, h, img)
      @color = color
    end

    def self.new_color(x, y, w, h, color)
      self.new(x, y, w, h, nil, color)
    end

    def self.new_single_image(x, y, img)
      mt = self.new(x, y, img.w, img.h, img)
      mt
    end

    def self.new_fill_image(x, y, w, h, img)
      mt = self.new(x, y, w, h, img)
      mt.fill_material
      mt
    end

    def fill_material
      x = @x; y = @y; max_x = @x + @w; max_y = @y + @h
      @fill_mtls = []
      while max_x > x
        while max_y > y
          cp_im = @img.copy_rect(0, 0, @img.w, @img.h)
          clip_w = (x + @img.w) > max_x ? (x + @img.w) - max_x : nil;
          clip_h = (y + @img.h) > max_y ? (y + @img.h) - max_y : nil;
          cp_im = cp_im.copy_rect(0, 0, clip_w, @img.h) if clip_w
          cp_im = cp_im.copy_rect(0, 0, @img.w, clip_h) if clip_h
          @fill_mtls << Material.new(x, y, 0, 0, cp_im)
          y += @img.h
        end
        x += @img.w
        y = @y
      end
      @img = nil
    end

    def put_screen(screen)
      case
      when @img
        screen.put(@img, @x, @y)
      when @fill_mtls
        @fill_mtls.each {|mtl|
          screen.put(mtl.img, mtl.x, mtl.y)
        }
      when @color
        screen.fill_rect(@x, @y, @w, @h, @color)
      end
    end

    def xy_move(add_x, add_y)
      @x += add_x
      @y += add_y
      if @fill_mtls
        @fill_mtls.each {|mtl|
          mtl.xy_move(add_x, add_y)
        }
      end
    end

    def x_move(add_x)
      xy_move(add_x, 0)
    end

    def y_move(add_y)
      xy_move(0, add_y)
    end
  end

  autoload :BackGround, "material/background"
  autoload :Floor, "material/floor"
  autoload :WeakBlock, "material/weakblock"
  autoload :ItemBox, "material/itembox"
  autoload :JumpCoin, "material/jumpcoin"
  autoload :StrongBlock, "material/strongblock"
  autoload :Pipe, "material/pipe"
  autoload :Pole, "material/pole"
  autoload :Goal, "material/goal"
end
