module Nario::Material
  class Floor < Material
    def head_range
      {:x_range => @x..(@x+@w), :y_range => (@y-1)..(@y+10), :event => :collide_floor_head}
    end
  end
end
