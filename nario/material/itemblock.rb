module Nario::Material
  class ItemBlock < Material
    BOUND_SPEED_RATE = -5

    def initialize(x, y, img=SDL::Surface.load("nario/image/item_block.bmp"))
      im = clean_bg(img.copy_rect(0, 0, 48, 46))
      @empty_img = clean_bg(img.copy_rect(144, 0, 48, 46))
      im1 = clean_bg(img.copy_rect(48, 0, 48, 46))
      im2 = clean_bg(img.copy_rect(96, 0, 48, 46))
      @blink_imgs = [im, im1, im2, im1, im, 0]
      super(x, y, im.w, im.h, im)
      @bound_speed = BOUND_SPEED_RATE
      @movie_event = :blinking
      @item = JumpCoin.new(@x + 7, @y - 70)
    end

    def collide_nario_head(m)
      change_img(@empty_img)
      @movie_event = :bound
      @bound_prev_y = @y
      @frame = 0
      @now_scene.in(:item, @item)
      undef :collide_nario_head
    end

    def blinking
      animate(@blink_imgs, 9)
    end

    def bound
      y_move(@bound_speed)
      @bound_speed += 3 if (@frame % 4).zero?
      if @y > @bound_prev_y
        @bound_speed = BOUND_SPEED_RATE
        @y = @bound_prev_y
        movie_end
      end
    end
  end
end
