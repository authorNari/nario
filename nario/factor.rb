module Nario
  class Factor
    attr_accessor :x, :y, :w, :h, :img, :foot, :head, :left, :right, :is_dead, :is_garbage, :frame, :now_scene, :movie_event
  
    def initialize(x, y, w, h, img=nil)
      @x = x
      @y = y
      @w = w
      @h = h
      @img = img
      w_delete = @w/6
      h_delete = @h/6
      @is_garbage = false
      @is_dead = false
      @movie_event = nil
      @frame = 0
      @now_scene = nil
    end
  
    def action
      send(@movie_event) if @movie_event
    end
  
    def collision_event(collide)
      event = nil
      return event unless collision_maybe? collide
      return event_call(event, collide) if event = have_event_range(foot_range, collide.head_range)
      return event_call(event, collide) if event = have_event_range(head_range, collide.foot_range)
      return event_call(event, collide) if event = have_event_range(leftside_range, collide.rightside_range)
      return event_call(event, collide) if event = have_event_range(rightside_range, collide.leftside_range)
    end
  
    def center
      [(@x+@w/2), (@y+@h/2)]
    end
  
    def head_range
      {:x_range => @x..(@x+@w), :y_range => @y..(@y+10), :event => ("collide_#{extract_class_name(self)}_head".to_sym)}
    end
  
    def leftside_range
      {:x_range => @x..(@x+@w/6), :y_range => @y..(@y+@h), :event => ("collide_#{extract_class_name(self)}_left".to_sym)}
    end
  
    def rightside_range
      {:x_range => (@x+@w-@w/6)..(@x+@w), :y_range => @y..(@y+@h), :event => ("collide_#{extract_class_name(self)}_right".to_sym)}
    end
  
    def foot_range
      {:x_range => @x..(@x+@w), :y_range => (@y+@h-10)..(@y+@h), :event => ("collide_#{extract_class_name(self)}_foot".to_sym)}
    end
  
    def garbage?
      @is_garbage
    end
  
    def dead?
      @is_dead
    end
  
    def xy_move(x, y)
      @x += x
      @y += y
    end
  
    def x_move(x)
      @x += x
    end
  
    def y_move(y)
      @y += y
    end
  
    def countup_frame
      @frame += 1
      @frame = 0 if @frame > 50000
    end
  
    private
    def animate(imgs, frame_time)
      if (@frame % frame_time).zero?
        index = imgs.last
        index = 0 if imgs.size-1 == index
        change_img(imgs[index])
        index += 1
        imgs[imgs.size-1] = index
      end
    end
  
    def extract_class_name(obj)
      obj.class.to_s.downcase[/\w+\z/]
    end
  
    def collision_maybe?(other)
      (center[0] - other.center[0]).abs < ((@w/2) + (other.w/2) + 20) and (center[1] - other.center[1]).abs < ((@h/2) + (other.h/2) + 20)
    end
  
    def event_call(event, other)
      is_or_dead = (@is_dead or other.is_dead)
      puts "event! #{self.class}\##{event[:self_event]} <--> #{other.class}\##{event[:other_event]}" if $DEBUG_EVENT_WATCH_MODE
      other.send(event[:self_event], self) if other.methods.map{|a| a.to_s}.include? event[:self_event].to_s and !is_or_dead
      send(event[:other_event], other) if methods.map{|b| b.to_s}.include? event[:other_event].to_s and !is_or_dead
    end
  
    def have_event_range(self_range, other_range)
      e = false
      return e unless self_range and other_range
      self_range[:x_range].each{|i| break e = true if other_range[:x_range].include? i}
      return e unless e
      e = false
      self_range[:y_range].each{|i| break e = true if other_range[:y_range].include? i}
      {:self_event => self_range[:event], :other_event => other_range[:event]} if e
    end
  
    def clean_bg(img)
      img.set_color_key(SDL::SRCCOLORKEY, [255, 255, 255])
      img
    end
  
    def change_img(img)
      @img = img
      @w = img.w
      @h = img.h
    end
  
    def movie_end
      @movie_event = nil
    end
  end
end
