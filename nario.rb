# super nario gc

$: << File.join(File.dirname(__FILE__), 'nario')

require 'sdl'
require_relative 'lib/fpstimer.rb'
require_relative 'lib/input.rb'
require_relative 'lib/sdl_helper.rb'
require 'optparse'

GC::Profiler.enable
$GAME_LEVEL = 0
$TEST_MODE = false
$DEBUG_EVENT_WATCH_MODE = false
$DEBUG_PLAYER_WATCH_MODE = false
opt = OptionParser.new
opt.version = "1.0.0"
opt.on('-l N', '--level N', "game level", Integer) {|n| $GAME_LEVEL = n}
opt.on('-t', '--test', "test mode") {|v| $TEST_MODE = true}
opt.on('--debug-event', "debug: event watch mode") {|v| $DEBUG_EVENT_WATCH_MODE = true}
opt.on('--debug-player', "debug: player watch mode") {|v| $DEBUG_PLAYER_WATCH_MODE = true}
opt.parse!(ARGV)

module Nario
  def self.burden
    $GAME_LEVEL.times do |i|
      (i * 200).times do |j|
        a = []
        1000.times{|i| a << i.to_s}
        eval("$burden_#{i}#{j} = a")
      end
    end
  end
end

Nario.burden

require_relative 'nario/color'
require_relative 'nario/scene'
require_relative 'nario/material'
require_relative 'nario/gamestart' unless $TEST_MODE
require_relative 'nario/test' if $TEST_MODE

GC::Profiler.report
puts "GC ave: #{GC::Profiler.total_time / GC.count * 100} ms"
