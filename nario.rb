# super nario gc

$: << File.join(File.dirname(__FILE__), 'nario')

require 'sdl'
require_relative 'lib/fpstimer.rb'
require_relative 'lib/input.rb'
require_relative 'lib/sdl_helper.rb'
require 'optparse'

$GC_BURDEN_MODE = false
$TEST_MODE = false
$DEBUG_EVENT_WATCH_MODE = false
$DEBUG_PLAYER_WATCH_MODE = false
opt = OptionParser.new
opt.version = "1.0.0"
opt.on('-g', '--gc', "To stop the world. and gc stop grafical mode :)") {|v| $GC_BURDEN_MODE = true}
opt.on('-t', '--test', "test mode") {|v| $TEST_MODE = true}
opt.on('--debug-event', "debug: event watch mode") {|v| $DEBUG_EVENT_WATCH_MODE = true}
opt.on('--debug-player', "debug: player watch mode") {|v| $DEBUG_PLAYER_WATCH_MODE = true}
opt.parse!(ARGV)

# burden to nario and gc :)
if $GC_BURDEN_MODE
  @@arry = []
  3000000.times{@@arry << Array.new}
  @@skip = 1

  def gc_start(screen)
    case @@skip
    when 30
      screen.put(SDL::Surface.load("nario/image/gc_start.bmp"), 270, 270)
      return @@skip = 0
    when 0
      @@skip = 1
      return GC.start()
    end
    @@skip += 1
  end
end

module Nario
end

require_relative 'nario/scene'
require_relative 'nario/material'
require_relative 'nario/gamestart' unless $TEST_MODE
require_relative 'nario/test' if $TEST_MODE
