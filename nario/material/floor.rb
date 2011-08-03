module Nario
  module Material
    class Floor < Material
      @@floor_block_image = nil

      def head_range
        {:x_range => @x..(@x+@w), :y_range => (@y-1)..(@y+10), :event => :collide_floor_head}
      end

      def self.floor_block_image
        if @@floor_block_image.nil?
          img = SDL::Surface.load("nario/image/floor_block.bmp")
          @@floor_block_image = img
        end
        @@floor_block_image
      end
    end
  end
end
