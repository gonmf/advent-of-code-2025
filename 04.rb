require 'set'

input = File.read('04.input')

# problem 1

floor_set = Set.new
floor_list = []

input.split("\n").each.with_index do |line, y|
  line.split('').each.with_index do |v, x|
    next if v != '@'

    floor_set.add([x, y])
    floor_list.push([x, y])
  end
end

total = 0
diffs = [[-1, -1], [0, -1], [1, -1], [-1, 1], [0, 1], [1, 1], [-1, 0], [1, 0]]

floor_list.each do |pos|
  x, y = pos
  occupied = 0

  diffs.each do |diff|
    diff_x, diff_y = diff

    occupied += 1 if floor_set.include?([x + diff_x, y + diff_y])
  end

  if occupied < 4
    total += 1
  end
end

p total

# problem 1

initial_rolls = floor_list.size

while true
  new_floor_set = Set.new
  new_floor_list = []

  floor_list.each do |pos|
    x, y = pos
    occupied = 0

    diffs.each do |diff|
      diff_x, diff_y = diff

      occupied += 1 if floor_set.include?([x + diff_x, y + diff_y])

      if occupied == 4
        new_floor_set.add(pos)
        new_floor_list.push(pos)
        break
      end
    end
  end

  break if new_floor_list.size == floor_list.size

  floor_set = new_floor_set
  floor_list = new_floor_list
end

p initial_rolls - floor_list.size
