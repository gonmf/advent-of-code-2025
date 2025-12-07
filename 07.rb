require 'set'

input = File.read('07.input').split("\n")

# problem 1

start = nil
splitter_set = Set.new
end_y = input.size

input.each.with_index do |line, y|
  line.split('').each.with_index do |val, x|
    if val == 'S'
      start = [x, y]
    elsif val == '^'
      splitter_set.add([x, y])
    end
  end
end

beams = [start]
splits = 0

while beams[0][1] < end_y
  new_beams = Set.new

  beams.each do |beam|
    x, y = beam
    if splitter_set.include?([x, y + 1])
      new_beams.add([x - 1, y + 1]) unless splitter_set.include?([x - 1, y + 1])
      new_beams.add([x + 1, y + 1]) unless splitter_set.include?([x + 1, y + 1])
      splits += 1
    else
      new_beams.add([x, y + 1])
    end
  end

  beams = new_beams.to_a
end

p splits

# problem 2

def count_timelines(splitter_set, beam, memo, end_y)
  memo[beam] ||= begin
    x, y = beam
    return 1 if y == end_y

    if splitter_set.include?([x, y + 1])
      count_timelines(splitter_set, [x - 1, y + 1], memo, end_y) + count_timelines(splitter_set, [x + 1, y + 1], memo, end_y)
    else
      count_timelines(splitter_set, [x, y + 1], memo, end_y)
    end
  end
end

p count_timelines(splitter_set, start, {}, end_y)
