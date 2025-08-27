def init args
  args.state.dragons = []
end

def separation dragon, dragons, min
  too_close = dragons.select{|d| d != dragon and Geometry.distance(dragon, d) <= min}
  desired_direction = 0
  too_close.each do |d|
    desired_direction += Geometry.angle_to(d, dragon)
  end
  if desired_direction != 0
    dragon.desired_direction = 360-desired_direction
    return true
  end
  return false
end

def direction dragon, dragons, min, max
  nearby = dragons.select {|d| d != dragon and Geometry.distance(dragon, d) <= max and Geometry.distance(dragon, d) > min}
  angles = []
  nearby.each do |d|
    angles << d.angle
  end
  if nearby.size > 0
    dragon.desired_direction += angles.sum / angles.size
    return true
  end
  return false
end

def group dragon, dragons, min, max
  nearby = dragons.select {|d| d != dragon and Geometry.distance(dragon, d) <= max and Geometry.distance(dragon, d) > min}
  x = []
  y = []
  nearby.each do |d|
    x << d.x
    y << d.y
  end
  if nearby.size > 0
    to_x = x.sum / x.size
    to_y = y.sum / y.size
    dragon.desired_direction += Geometry.angle_to({x: to_x, y: to_y}, dragon)
    dragon.desired_direction = dragon.desired_direction / 2
    return true
  end
  return false
end

#Better design would be to get a vector from each rule and apply them with weights.S
def process dragon, dragons, args
  if Geometry.distance(dragon, {x:640, y:360}) > 5
    dragon.desired_direction = Geometry.angle_to(dragon, args.inputs.mouse)
  else
    separation(dragon, dragons, 100)
    direction(dragon, dragons, 0, 640)
    group(dragon, dragons, 0, 1280)
  end
  if dragon.angle < dragon.desired_direction
    dragon.angle += [5, dragon.desired_direction - dragon.angle].min()
  else
    dragon.angle -= [5, dragon.angle - dragon.desired_direction].min()
  end

  a_rad = dragon.angle.to_radians()
  dragon.x += Math.cos(a_rad) * 5
  dragon.y += Math.sin(a_rad) * 5
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

  if args.inputs.keyboard.space or args.inputs.mouse.button_left or args.state.dragons.size < 15
    args.state.dragons << new_dragon
  end

  args.state.dragons = args.state.dragons.map{|d| process(d, args.state.dragons, args)}
  args.state.dragons = args.state.dragons.select{|d| d.x > 0 and d.x < 1280 and d.y> 0 and d.y < 720}

  args.outputs.primitives << args.state.dragons

end
