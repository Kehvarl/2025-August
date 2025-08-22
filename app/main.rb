def init args
  args.state.dragons = []
end

def separation dragon, dragons, min
  too_close = dragons.select{|d| d != dragon and Geometry.distance(dragon, d) <= min}
  desired_direction = 0
  too_close.each do |d|
    desired_direction += Geometry.angle_from(d, dragon)
  end
  if desired_direction != 0
    dragon.angle = desired_direction
    return true
  end
  return false
end

def direction dragon, dragons, range
  nearby = dragons.select{|d| d != dragon and Geometry.distance(dragon, d) <= range}
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

def process dragon, dragons
  if not separation(dragon, dragons, 100)
    direction(dragon, dragons, 400)
  end
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

  args.outputs.primitives << args.state.dragons

end
