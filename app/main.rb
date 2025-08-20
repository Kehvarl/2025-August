def init args
  args.state.dragons = []
end

def process dragon, dragons
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
