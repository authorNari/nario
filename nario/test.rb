require_relative 'life'

class Input
  define_key SDL::Key::ESCAPE, :exit
  define_key SDL::Key::LEFT, :left
  define_key SDL::Key::RIGHT, :right
  define_key SDL::Key::UP, :up
  define_key SDL::Key::DOWN, :down
  define_key SDL::Key::RETURN, :ok
  define_key SDL::Key::A, :a
  define_key SDL::Key::B, :b
end

SDL.init(SDL::INIT_VIDEO|SDL::INIT_JOYSTICK)
SDL::TTF.init

module Nario
  def self.test_screen(*proc)
    if defined?(SDL::RELEASE_MODE)
      SDL::Mouse.hide
      screen = SDL.set_video_mode(Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT, 16, SDL::HWSURFACE|SDL::DOUBLEBUF|SDL::FULLSCREEN)
    else
      screen = SDL.set_video_mode(Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT, 16, SDL::SWSURFACE|SDL::DOUBLEBUF)
    end

    @input = Input.new
    timer = FPSTimerLight.new
    timer.reset
    loop do
      @input.poll
      break if @input[:exit]
      proc.each{|p|
        p.call(@input, screen)
      }
      timer.wait_frame{
        if defined?(SDL::RELEASE_MODE)
          screen.flip
        else
          screen.update_rect(0, 0, Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT)
        end
      }
    end
  end

  test_fill_material = lambda {|input, screen|
    mt = Material::BackGround.new_fill_image(30, 230, 230, 200, SDL::Surface.load("nario/image/floor_block.bmp"))
    mt.put_screen(screen)
  }

  test_img_material = lambda {|input, screen|
    mt = Material::BackGround.new_single_image(30, 130, SDL::Surface.load("nario/image/floor_block.bmp"))
    mt.put_screen(screen)
  }

  test_color_material = lambda {|input, screen|
    mt = Material::BackGround.new_color(200, 0, 100, 300, [100, 10, 0])
    mt.put_screen(screen)
  }

  mt_sfm = Material::BackGround.new_fill_image(100, 0, 100, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
  test_scroll_fill_material = lambda {|input, screen|
    mt_sfm.scroll(1, 1)
    mt_sfm.put_screen(screen)
  }

  mt_sim = Material::BackGround.new_single_image(130, 0, SDL::Surface.load("nario/image/floor_block.bmp"))
  test_scroll_img_material = lambda {|input, screen|
    mt_sim.scroll(20, 0)
    mt_sim.put_screen(screen)
  }

  mt_scm = Material::BackGround.new_color(20, 0, 100, 300, [100, 10, 0])
  test_scroll_color_material = lambda {|input, screen|
    mt_scm.scroll(2, 1)
    mt_scm.put_screen(screen)
  }

  reset_background = lambda {|input, screen|
    screen.fill_rect(0, 0, 1000, 1000, [0, 0, 0])
  }

  chibi_nario_test = {}
  chibi_nario_test[:map_1] = Scene::FlowWorld.new{ success :map_1 }
  chibi_nario_test[:map_1].build_scene {|s|
    background Material::BackGround.new_color(0, 0, 10000, 800, [0x00, 0x99, 0xff])
    floor Material::Floor.new_fill_image(0, 600, 200, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(350, 600, 500, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(900, 600, 500, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(1500, 600, 200, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(1800, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(2600, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(3200, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(3800, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(4400, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    floor Material::Floor.new_fill_image(5000, 600, 400, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    #  floor Material::Floor.new_color(0, 600, 800, 300, [0xcc, 0x66, 0x66])
    #  floor Material::Floor.new_color(1000, 600, 800, 300, [0xcc, 0x66, 0x66])
    enemy Life::Can.new(500, 200)
    player Life::Nario.new(40, 200)
  }

  test_chibi_nario_move = lambda {|input, screen|
    chibi_nario_test[:map_1].act(input)
    chibi_nario_test[:map_1].render(screen)
  }

  fear_nario_test = {}
  fear_nario_test[:map_1] = Scene::FlowWorld.new{ success :map_1 }
  fear_nario_test[:map_1].build_scene {|s|
    background Material::BackGround.new_color(0, 0, 6000, 800, [0x00, 0x99, 0xff])
    floor Material::Floor.new_fill_image(0, 600, 800, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    #  floor Material::Floor.new_color(0, 600, 800, 300, [0xcc, 0x66, 0x66])
    #  floor Material::Floor.new_color(1000, 600, 800, 300, [0xcc, 0x66, 0x66])
    enemy Life::Can.new(100, 0)
    enemy Life::Can.new(200, 0)
    enemy Life::Can.new(300, 0)
    enemy Life::Can.new(400, 0)
    enemy Life::Can.new(500, 0)
    enemy Life::Can.new(600, 0)
    enemy Life::Can.new(700, 0)
    player Life::Nario.new(40, 590)
  }

  test_fear_nario_move = lambda {|input, screen|
    fear_nario_test[:map_1].act(input)
    fear_nario_test[:map_1].render(screen)
  }

  block_test = {}
  block_test[:map_1] = Scene::FlowWorld.new{ success :map_1 }
  block_test[:map_1].build_scene {|s|
    background Material::BackGround.new_color(0, 0, 6000, 800, [0x00, 0x99, 0xff])
    block Material::Pipe.new(500, 480)
    floor Material::Floor.new_fill_image(0, 630, 5000, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    block Material::WeakBlock.new(100, 500)
    block Material::WeakBlock.new(146, 500)
    block Material::WeakBlock.new(192, 500)
    block Material::ItemBox.new(238, 500)
    block Material::WeakBlock.new(284, 500)
    block Material::WeakBlock.new(330, 500)
    block Material::WeakBlock.new(376, 500)
    block Material::ItemBox.new(420, 500)
    enemy Life::Dustbin.new(300, 0)
    player Life::Nario.new(40, 590)
  }

  test_brock = lambda {|input, screen|
    block_test.act(input)
    block_test.render(screen)
  }

  goal_test = {}
  goal_test[:map_1] = Scene::FlowWorld.new{ success :map_1 }
  goal_test[:map_1].build_scene {|s|
    floor Material::Floor.new_fill_image(0, 630, 5000, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    goal 800
    player Life::Nario.new(40, 590)
  }

  test_goal = lambda {|input, screen|
    goal_test[:map_1].act(input)
    goal_test[:map_1].render(screen)
  }

  goal_test[:map_1] = Scene::FlowWorld.new{ success :map_1 }
  goal_test[:map_1].build_scene {|s|
    background Material::BackGround.new_color(0, 0, 6000, 800, [0x00, 0x99, 0xff])
    floor Material::Floor.new_fill_image(0, 630, 5000, 300, SDL::Surface.load("nario/image/floor_block.bmp"))
    left_triangle_block(Material::StrongBlock, 200, 5)
    right_triangle_block(Material::StrongBlock, 800, 5, 6)
    player Life::Nario.new(40, 590)
  }
  test_triangle = lambda {|input, screen|
    goal_test[:map_1].act(input)
    goal_test[:map_1].render(screen)
  }

  # image test
  #test_screen(
  #             reset_background,
  #             test_fill_material,
  #             test_img_material,
  #             test_color_material,
  #             test_scroll_fill_material,
  #             test_scroll_img_material,
  #             test_scroll_color_material
  #)

  # player move test
  # test_screen(
  #   test_chibi_nario_move
  # )

  # player fear
  #test_screen(
  #  test_fear_nario_move
  #)

  # block test
  # test_screen(
  #   test_brock
  # )

  # goal test
  test_screen(
              test_goal
              )
end
