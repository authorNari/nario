#
# input.rb - version 20061223
#

class Input
  AXIS_THRESHOLD = 500
  REPEAT_THRESHOLD = 19
  REPEAT_SPEED = 6
  REPEATS = []
  KEY_MAP = {}
  KeyMapInfo = Struct.new(:name, :mod)
  MOD_MAP = {
    :ctrl  => SDL::Key::MOD_CTRL,
    :shift => SDL::Key::MOD_SHIFT,
    :alt   => SDL::Key::MOD_ALT,
    :meta  => SDL::Key::MOD_META,
  }
  JOYHAT_MAP = {
    SDL::Joystick::HAT_UP    => :up,
    SDL::Joystick::HAT_RIGHT => :right,
    SDL::Joystick::HAT_DOWN  => :down,
    SDL::Joystick::HAT_LEFT  => :left
  }
  JOYBUTTON_MAP = {}

  def self.define_key_ctrl( key,name,repeats=false); define_key(key,name,repeats,:ctrl)  ; end
  def self.define_key_shift(key,name,repeats=false); define_key(key,name,repeats,:shift) ; end
  def self.define_key_alt(  key,name,repeats=false); define_key(key,name,repeats,:alt)   ; end
  def self.define_key_meta( key,name,repeats=false); define_key(key,name,repeats,:meta)  ; end

  def self.define_key(key, name, repeats = false, mod=nil)
    KEY_MAP[key] = KeyMapInfo.new(name, MOD_MAP[mod])
    module_eval <<-EOD
      def #{name}
        @info[:#{name}]
      end
    EOD
    if repeats
      REPEATS << name 
    end
  end

  def self.define_pad_button(button, name)
    JOYBUTTON_MAP[button] = name
    module_eval <<-EOD
      def #{name}
        @info[:#{name}]
      end
    EOD
  end

  def initialize
    #ジョイスティックの初期化
    if SDL::Joystick.num > 0
      @joystick = SDL::Joystick.open(0)
    else
      @joystick = Object.new    #ダミーのジョイスティックをつくる
      def @joystick.axis(i)   ; 0     ; end
      def @joystick.hat(i)    ; nil   ; end
      def @joystick.button(i) ; false ; end
    end

    @stopped = false
    @repeat_ct = Hash.new(0)
    clear
  end
  attr_accessor :stopped
  attr_reader :info

  def clear
    @info = {}
  end

  def poll
    clear

    #scan
    SDL::Key.scan
    KEY_MAP.each do |key, info|
      if SDL::Key.press?(key) 
        if info.mod.nil? || (SDL::Key.mod_state & info.mod)
          set_pressed(info.name)
        end
      end
    end
    JOYBUTTON_MAP.each do |button, name|
      set_pressed(name) if @joystick.button(button)
    end
    set_pressed(axis2name(0, @joystick.axis(0)))
    set_pressed(axis2name(1, @joystick.axis(1)))
    set_pressed(JOYHAT_MAP[@joystick.hat(0)])
    
    #event
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        set_pushed(:exit)
      when SDL::Event2::KeyDown
        if (info = KEY_MAP[event.sym])
          if info.mod.nil? || (event.mod & info.mod)
            set_pushed(info.name)
          end
        end
      when SDL::Event2::JoyAxis
        set_pushed(axis2name(event.axis, event.value))
      when SDL::Event2::JoyHat
        set_pushed(JOYHAT_MAP[event.value])
      when SDL::Event2::JoyButtonDown
        set_pushed(JOYBUTTON_MAP[event.button])
      end
    end

  end

  def axis2name(axis, value)
    case axis
    when 0
      if value > AXIS_THRESHOLD
        :right
      elsif value < -AXIS_THRESHOLD
        :left
      end
    when 1
      if value > AXIS_THRESHOLD
        :down
      elsif value < -AXIS_THRESHOLD
        :up
      end
    end
  end

  def set_pushed(name)
    @info[name] = :push
    @repeat_ct = Hash.new(0)
  end

  def set_pressed(name)
    return if name.nil?

    @info[name] = :press

    if REPEATS.include? name
      @repeat_ct[name] += 1
      diff = @repeat_ct[name] - REPEAT_THRESHOLD

      if diff == 0
        @info[name] = :push
      elsif diff > REPEAT_SPEED
        @info[name] = :push
        @repeat_ct[name] = REPEAT_THRESHOLD
      end
    end
  end

  def pushed?(name)
    @info[name] == :push && (not @stopped)
  end

  def pressed?(name)
    @info[name] && (not @stopped)
  end
  alias :[] :pressed?

  def pushed_first
    if (keys = @info.find{|name,type| type==:push}) && (not @stopped)
      keys.first
    else
      nil
    end
  end

end

