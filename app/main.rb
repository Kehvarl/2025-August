def init args
  args.state.blocks = []
end

def calc_physics args
  args.state.blocks.each do |b|
    b.y -= b.vy
    if b.y <= 0
      b.vy = 0
    end
  end
end

def add_block args
  args.state.blocks << {
    x: rand(1280), y: rand(100) + 620, w: 8, h: 8,
    path: "sprites/square/blue.png",
    vy: 1
    }
end

def tick args
  if args.tick_count == 0
    init(args)
    add_block(args)
  end

  if args.inputs.keyboard.space or args.inputs.mouse.button_left
    add_block(args)
  end

  calc_physics(args)

  args.outputs.primitives << args.state.blocks

end
