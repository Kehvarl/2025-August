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
  end
end

def process dragon, dragons
  separation dragon, dragons, 100
  return dragon
end

def new_dragon
  {
    x: rand(1280), y: rand(720), w: 32, h: 24,
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
