def init args
  args.state.falling = []
  args.state.landed = []
end

def calc_physics args
  args.state.falling.each do |b|
    b.y -= b.vy
    if b.y <= 0 or args.geometry.find_all_intersect_rect(b, args.state.landed).any?
      b.vy = 0
      args.state.landed << b
    end
  end
  args.state.falling.reject!{|f| f.vy <= 0}
end

def add_block args
  args.state.falling << {
    x: rand(1280), y: rand(50) + 670, w: 8, h: 8,
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

  if args.inputs.keyboard.c
    puts args.state.landed.size
  end

  calc_physics(args)

  args.outputs.primitives << args.state.landed

  args.outputs.primitives << args.state.falling

end
