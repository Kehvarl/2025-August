def init args
  args.state.falling = []
  args.state.landed = []
  args.state.heights = Array.new(1280,0)
end

def calc_physics args
  args.state.falling.each do |b|
    b.y -= b.vy
    b.x += b.vx
    if b.x < 0 or b.x > 1280
      b.x = b.x.clamp(0,1280)
      b.vx = -b.vx
    end
    if args.state.heights[b.x...b.x+b.w].any?{|h| b.y <= h}
      b.vy = 0
      args.state.landed << b
      args.state.heights[b.x...b.x+b.w].each_with_index do |h,i|
        args.state.heights[i+b.x] += b.h
      end
    end
  end
  args.state.falling.reject!{|f| f.vy <= 0}
end

def add_block args
  args.state.falling << {
    x: rand(1280), y: rand(50) + 670, w: 4, h: 4,
    path: "sprites/square/blue.png",
    vy: 1, vx: [-1,-0.5,-0.25,-0.1,0,0.1,0.25,0.5,1].sample()
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
    puts args.state.falling.size
    puts args.state.landed.size
  end

  calc_physics(args)

  args.outputs.primitives << args.state.landed

  args.outputs.primitives << args.state.falling

end
