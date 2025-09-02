class Rule
  attr_accessor :vx, :vy
  def initialize
    @vx = 0
    @vy = 0
  end

  def a2v angle
    a_rad = angle.to_radians()
    return Math.cos(a_rad), Math.sin(a_rad)
  end

  def process dragon, dragons
    @vx, @vx = 0,0
    return {x: @vx, y: @vy}
  end
end

class Separate < Rule
  def initialize (max)
    super()
    @max = max
  end

  def process dragon, dragons
    @vx, @vx = 0,0
    too_close = dragons.select{|d| d != dragon and Geometry.distance(dragon, d) <= @max}
    too_close.each do |d|
      dx, dy = a2v(Geometry.angle_to(d, dragon))
      @vx += dx
      @vy += dy
    end
    if too_close.size > 0
      @vx /= too_close.size()
      @vy /= too_close.size()
    end
    return {x: @vx, y: @vy}
  end
end

class Align < Rule
  def initialize (min, max)
    super()
    @min = min
    @max = max
  end

  def process dragon, dragons
    @vx, @vx = 0,0
    nearby = dragons.select{|d| d != dragon and
                            Geometry.distance(dragon, d) > @min and
                           Geometry.distance(dragon, d) <= @max}
    nearby.each do |d|
      dx, dy = a2v(d.angle)
      @vx += dx
      @vy += dy
    end
    if nearby.size > 0
      @vx /= nearby.size()
      @vy /= nearby.size()
    end
    return {x: @vx, y: @vy}
  end
end

class Group < Rule
  def initialize (min, max)
    super()
    @min = min
    @max = max
  end

  def process dragon, dragons
    x = []
    y = []
    nearby = dragons.select{|d| d != dragon and
                            Geometry.distance(dragon, d) > @min and
                           Geometry.distance(dragon, d) <= @max}
    nearby.each do |d|
      x << d.x
      y << d.y
    end
    if nearby.size > 0
      @vx = x.sum/x.size
      @vy = y.sum/y.size
    end
    return {x: @vx, y: @vy}
  end
end


def init args
  args.state.dragons = []
  args.state.rules = [
    Separate.new(200),
    Align.new(0, 400),
    Group.new(0,1280)
  ]
end

def a2v angle
  a_rad = angle.to_radians()
  return Math.cos(a_rad), Math.sin(a_rad)
end

#Better design would be to get a vector from each rule and apply them with weights.S
def process dragon, dragons, args

  vx,vy = 0,0
  args.state.rules.each do |rule|
    s = rule.process(dragon, dragons)
    vx += s.x
    vy += s.y
  end

  desired_angle = Math.atan2(vy, vx).to_degrees
  dragon.desired_direction = desired_angle + (rand(21) - 10)
  diff = ((dragon.desired_direction - dragon.angle + 180) % 360) - 180
  dragon.angle += diff.clamp(-5, 5)
  vx, vy = a2v(dragon.angle)

  dragon.x += vx
  dragon.y += vy

  return dragon
end

def new_dragon
  rand_a = rand(359)
  {
    x: rand(1280), y: rand(720), w: 32, h: 24,
    angle: rand_a, desired_direction: rand_a,
    path: "sprites/misc/dragon-0.png"
    }
end

def tick args
  if args.tick_count == 0
    init(args)
  end

  if args.inputs.keyboard.space or args.inputs.mouse.button_left or args.state.dragons.size < 25
    args.state.dragons << new_dragon
  end

  args.state.dragons = args.state.dragons.each{|d| process(d, args.state.dragons, args)}
  args.state.dragons = args.state.dragons.select{|d| d.x > 0 and d.x < 1280 and d.y> 0 and d.y < 720}

  args.outputs.primitives << args.state.dragons

end
