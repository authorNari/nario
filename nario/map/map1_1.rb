module Nario
  module Map
    MAP1_1 = lambda {|s|
      sky 12000
      ground 12000, 600

      block Material::ItemBox.new(800, 420)
      block Material::WeakBlock.new(1000, 420)
      block Material::ItemBox.new(1047, 420)
      block Material::WeakBlock.new(1094, 420)
      block Material::ItemBox.new(1141, 420)
      block Material::WeakBlock.new(1188, 420)
      block Material::ItemBox.new(1094, 240)
      block Material::Pipe.new(1370, 505)
      block Material::Pipe.new(1840, 460)
      block Material::Pipe.new(2280, 415)
      block Material::Pipe.new(2720, 415)
      block Material::WeakBlock.new(3730, 420)
      block Material::ItemBox.new(3777, 420)
      block Material::WeakBlock.new(3824, 420)
      block Material::WeakBlock.new(3871, 240)
      block Material::WeakBlock.new(3918, 240)
      block Material::WeakBlock.new(3965, 240)
      block Material::WeakBlock.new(4012, 240)
      block Material::WeakBlock.new(4059, 240)
      block Material::WeakBlock.new(4106, 240)
      block Material::WeakBlock.new(4153, 240)
      block Material::WeakBlock.new(4200, 240)
      block Material::WeakBlock.new(4400, 240)
      block Material::WeakBlock.new(4447, 240)
      block Material::WeakBlock.new(4494, 240)
      block Material::ItemBox.new(4541, 240)
      block Material::WeakBlock.new(4541, 420)
      block Material::WeakBlock.new(4900, 420)
      block Material::WeakBlock.new(4947, 420)
      block Material::ItemBox.new(5200, 420)
      block Material::ItemBox.new(5300, 420)
      block Material::ItemBox.new(5300, 240)
      block Material::ItemBox.new(5400, 420)
      block Material::WeakBlock.new(5600, 420)
      block Material::WeakBlock.new(5750, 240)
      block Material::WeakBlock.new(5797, 240)
      block Material::WeakBlock.new(5844, 240)
      block Material::WeakBlock.new(6050, 240)
      block Material::ItemBox.new(6097, 240)
      block Material::ItemBox.new(6144, 240)
      block Material::WeakBlock.new(6191, 240)
      block Material::WeakBlock.new(6097, 420)
      block Material::WeakBlock.new(6144, 420)
      block Material::Pipe.new(7900, 505)
      block Material::WeakBlock.new(8150, 420)
      block Material::WeakBlock.new(8197, 420)
      block Material::ItemBox.new(8244, 420)
      block Material::WeakBlock.new(8291, 420)
      block Material::Pipe.new(8700, 505)


      floor Material::Floor.new_fill_image(0, 600, 3270, 100, SDL::Surface.load("nario/image/floor_block.bmp"))
      floor Material::Floor.new_fill_image(3420, 600, 700, 100, SDL::Surface.load("nario/image/floor_block.bmp"))
      floor Material::Floor.new_fill_image(4300, 600, 3000, 100, SDL::Surface.load("nario/image/floor_block.bmp"))
      floor Material::Floor.new_fill_image(7450, 600, 3000, 100, SDL::Surface.load("nario/image/floor_block.bmp"))


      left_triangle_block Material::StrongBlock, 6350, 4
      right_triangle_block Material::StrongBlock, 6650, 4
      left_triangle_block Material::StrongBlock, 7082, 4, 5
      right_triangle_block Material::StrongBlock, 7450, 4
      left_triangle_block Material::StrongBlock, 8820, 8, 9

      goal 9860

      enemy Life::Can.new(900, 550)
      enemy Life::Can.new(2000, 550)
      enemy Life::Can.new(2500, 550)
      enemy Life::Can.new(2560, 550)
      enemy Life::Can.new(3830, 200)
      enemy Life::Can.new(3890, 200)
      enemy Life::Can.new(4670, 550)
      enemy Life::Can.new(4730, 550)
      enemy Life::Dustbin.new(5100, 550)
      enemy Life::Can.new(5430, 550)
      enemy Life::Can.new(5490, 550)
      enemy Life::Can.new(5750, 550)
      enemy Life::Can.new(5810, 550)
      enemy Life::Can.new(6100, 550)
      enemy Life::Can.new(6160, 550)
      enemy Life::Can.new(8300, 550)
      enemy Life::Can.new(8360, 550)

      player Life::Nario.new(200, 550)
    }
  end
end
