require_relative 'scene'
require_relative 'material'
require_relative 'life'
require_relative 'map'

# key config(SDL <--> nario)
class Input
  define_key SDL::Key::ESCAPE, :exit
  define_key SDL::Key::Q, :exit
  define_key SDL::Key::LEFT, :left
  define_key SDL::Key::RIGHT, :right
  define_key SDL::Key::UP, :up
  define_key SDL::Key::DOWN, :down
  define_key SDL::Key::RETURN, :ok
  define_key SDL::Key::A, :a
  define_key SDL::Key::B, :b
  define_key SDL::Key::S, :start
  define_key SDL::Key::G, :go
end

module Nario
  # nario make map
  def self.creation_nario_world(screen)
    world = {}
    world[:title] = Scene::Title.new { success :map1_1 }
    world[:title].build_scene &Map::TITLE
    world[:map1_1] = Scene::FlowWorld.new { success :title; miss :title }
    world[:map1_1].build_scene &Map::MAP1_1
    world
  end

  def self.setup_sdl
    SDL.init(SDL::INIT_JOYSTICK)
    SDL::TTF.init
    SDL.set_video_mode(Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT, 16, SDL::HWSURFACE|SDL::DOUBLEBUF)
  end

  @stop = false
  def self.stop?(input, screen)
    if input.start
      screen.put(SDL::Surface.load("nario/image/stop.bmp"), 270, 270)
      screen.update_rect(0, 0, Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT)
      @stop = true
    end
    if input.go
      @stop = false
    end
    return @stop
  end

  def self.go_nario!
    screen = setup_sdl()
    world = creation_nario_world(screen)

    input = Input.new
    timer = FPSTimerLight.new
    timer.reset
    scene = world[:title]

    # main loop
    loop {
      input.poll
      break if input[:exit]
      redo if stop?(input, screen)

      s_next = scene.act(input)
      scene.render(screen)
      scene = world[s_next].rebuild if s_next
      timer.wait_frame {
        gc_start(screen) if $GC_BURDEN_MODE
        screen.update_rect(0, 0, Scene::SCREEN_WIDTH, Scene::SCREEN_HIGHT)
      }
    }
  end

  go_nario!
end
