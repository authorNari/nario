#example map define
# map = Scene::Builder.new{
#   mapping :title, Scene::Title.new {
#     success :map_1
#   }
#   mapping :map_1, Scene::FlowWorld.new{
#     success :map_2
#   }
# }.scene_map

module Nario
  module Scene
    SCREEN_WIDTH = 760
    SCREEN_HIGHT = 670

    class Scene
      attr_accessor :backgrounds, :actions, :blocks, :enemys, :flows, :makers, :player, :renders

      def initialize(&block)
        init
        instance_eval(&block)
      end

      def init
        @backgrounds = []
        @actions = []
        @blocks = []
        @enemys = []
        @flows = []
        @makers = []
        @floors = []
        @player = nil
        @renders = [@flows]
        @lazy_deploys = []
      end

      def success(nxt)
        @success = nxt
      end

      def miss(nxt)
        @miss = nxt
      end

      def in(type, *args)
        send(type, *args)
      end
      
      def rebuild
        init
        instance_eval(&@build_code)
        self
      end

      def build_scene(&block)
        @build_code = block
        instance_eval(&block)
        self
      end

      private
      def background(bg)
        code = lambda {
          bg.now_scene = self
          @backgrounds << bg
        }
        @flows << bg
        add_lazydeploy(bg, code)
      end

      def floor(fl)
        code = lambda {
          fl.now_scene = self
          @blocks << fl
        }
        @floors << fl
        @flows << fl
        add_lazydeploy(fl, code)
      end

      def player(player)
        player.now_scene = self
        @player = player
      end

      def enemy(enemy)
        code = lambda {
          enemy.now_scene = self
          @actions << enemy
          @enemys << enemy
        }
        @flows << enemy
        add_lazydeploy(enemy, code)
      end

      def block(block)
        code = lambda {
          block.now_scene = self
          @blocks << block
          @actions << block
        }
        @floors << block
        @flows << block
        add_lazydeploy(block, code)
      end

      def item(it)
        code = lambda {
          it.now_scene = self
          @flows << it
          @actions << it
        }
        add_lazydeploy(it, code)
      end

      def goal(x)
        b = Material::BackGround.new_single_image(x, 0, SDL::Surface.load("nario/image/castle.bmp"))
        g = Material::Goal.new(x + 100, 0)
        sb = Material::StrongBlock.new(x - 200, 0)
        p = Material::Pole.new(x - 188, 0)
        background set_floor_up_y(b)
        block set_floor_up_y(g)
        block set_floor_up_y(sb)
        block set_floor_up_y(p)
      end

      def left_triangle_block(klass, x, step, floor_num=nil)
        floor_num ||= step
        while step.nonzero?
          x_b = x
          obj = nil
          floor_num.times{|i|
            obj = klass.new(x_b, 0)
            block set_floor_up_y(obj)
            x_b += obj.h + 1
          }
          floor_num-=1
          x += obj.h
          step-=1
        end
      end

      def right_triangle_block(klass, x, step, floor_num=nil)
        floor_num ||= step
        while step.nonzero?
          x_b = x
          obj = nil
          floor_num.times{|i|
            obj = klass.new(x_b, 0)
            block set_floor_up_y(obj)
            x_b += obj.h + 1
          }
          floor_num-=1
          step-=1
        end
      end

      def sky(max_x)
        background Material::BackGround.new_color(0, 0, 11000, 800, [0xff, 0xff, 0xfe])
        x = 0
        while max_x > 0
          x+=300
          background Material::BackGround.new_single_image(x, 100, SDL::Surface.load("nario/image/cloud1.bmp"))
          x+=300
          background Material::BackGround.new_single_image(x, 50, SDL::Surface.load("nario/image/cloud3.bmp"))
          x+=400
          background Material::BackGround.new_single_image(x, 30, SDL::Surface.load("nario/image/cloud2.bmp"))
          max_x-=(300+300+400)
        end
      end

      def ground(max_x, floor)
        x = 0
        while max_x > 0
          b1 =  Material::BackGround.new_single_image(x, floor, SDL::Surface.load("nario/image/bush2.bmp"))
          x+=500
          b1.y_move(-b1.h)
          background b1
          m = Material::BackGround.new_single_image(x, floor, SDL::Surface.load("nario/image/mountain.bmp"))
          x+=500
          m.y_move(-m.h)
          background m
          max_x-=(300+400)
        end
      end

      def deploy
        @lazy_deploys.each_with_index {|e, i|
          if e[:object].x < (SCREEN_WIDTH + SCREEN_WIDTH/2)
            e[:deploy_code].call
            @lazy_deploys[i] = nil
          end
        }
        @lazy_deploys.compact!
      end

      def add_lazydeploy(object, deploy_code)
        @lazy_deploys << {:object => object, :deploy_code => deploy_code}
      end

      def set_floor_up_y(s)
        y = SCREEN_HIGHT
        @floors.each{|b| y = b.y if ((b.x)..(b.x+b.w)).include? s.x and y > b.y}
        y -= s.h
        s.y_move(y)
        s
      end
    end

    autoload :Builder, "scene/builder"
    autoload :Title, "scene/title"
    autoload :FlowWorld, "scene/flowworld"
  end
end
