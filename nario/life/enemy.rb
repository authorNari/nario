module Nario::Life
  class Enemy < Life
    #collision events
    def collide_strongblock_left(s)  set_direction(-1) end
    def collide_strongblock_right(s) set_direction(1)  end
    def collide_floor_head(f)        stand_up(f)       end

    def collide_carapace_left(c)
      return clash(c) if c.violence?
      collide_strongblock_left(c)
    end

    def collide_carapace_right(c)
      return clash(c) if c.violence?
      collide_strongblock_right(c)
    end

    alias collide_weakblock_head collide_floor_head
    alias collide_itembox_head collide_weakblock_head
    alias collide_can_left collide_strongblock_left
    alias collide_can_right collide_strongblock_right
    alias collide_dustbin_left collide_strongblock_left
    alias collide_dustbin_right collide_strongblock_right
    alias collide_pipe_left collide_strongblock_left
    alias collide_pipe_right collide_strongblock_right

    def clash(carapace)
      @is_dead = true
      change_img(clean_bg(@img.rotate_surface(180, [255, 255, 255])))
      frame_reset
      return force_jump
    end
  end
end
