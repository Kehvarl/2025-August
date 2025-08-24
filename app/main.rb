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
    dragon.angle = 360-desired_direction
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
    dragon.angle = angles.sum / angles.size
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
    dragon.angle = Geometry.angle_to({x: to_x, y: to_y}, dragon)
    return true
  end
  return false
end

def process dragon, dragons
  if not separation(dragon, dragons, 100)
    if not direction(dragon, dragons, 100, 600)
      group(dragon, dragons, 100, 800)
    end
  end

  a_rad = dragon.angle.to_radians()
  dragon.x += Math.cos(a_rad) * 10
  dragon.y += Math.sin(a_rad) * 10
  return dragon

end

def new_dragon
  {
    x: rand(1280), y: rand(720), w: 32, h: 24,
    angle: 0,
    path: "sprites/misc/dragon-0.png"
    }
end

def tick args
  if args.tick_count == 0
    init(args)
  end

  if args.inputs.keyboard.space or args.inputs.mouse.button_left
    args.state.dragons << new_dragon
  end

  args.state.dragons = args.state.dragons.map{|d| process(d, args.state.dragons)}
  args.state.dragons = args.state.dragons.select{|d| d.x > 0 and d.x < 1280 and d.y> 0 and d.y < 720}

  args.outputs.primitives << args.state.dragons

end
