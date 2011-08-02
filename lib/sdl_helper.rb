class << SDL::Surface
  alias :org_load :load
end

class SDL::Surface
  def self.load(path)
    org_load("#{File.join(File.dirname(__FILE__), "..")}/#{path}")
  end

  def rotate_surface(angle, color)
    transform_surface(color, angle, 1, 1, 2)
  end
end

