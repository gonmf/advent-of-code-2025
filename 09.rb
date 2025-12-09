require 'set'

input = File.read('09.input').split("\n")

# problem 1

def square_area(tile1, tile2)
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]).abs + 1)
end

tiles = []

input.each do |line|
  tiles.push(line.split(',').map(&:to_i))
end

largest_area = 0

tiles.each.with_index do |tile1, idx1|
  tiles.each.with_index do |tile2, idx2|
    next if idx1 <= idx2

    area = square_area(tile1, tile2)
    largest_area = [area, largest_area].max
  end
end

p largest_area

# problem 2

x_original_values = []
y_original_values = []
x_compact_values = {}
y_compact_values = {}

all_x_values = tiles.map { |t| t[0] }.uniq.sort
all_x_values.each.with_index do |x, idx|
  x_compact_values[x] = idx
  x_original_values.push(x)
end

all_y_values = tiles.map { |t| t[1] }.uniq.sort
all_y_values.each.with_index do |y, idx|
  y_compact_values[y] = idx
  y_original_values.push(y)
end

new_tiles = []
tiles.each do |tile|
  new_tiles.push([x_compact_values[tile[0]], y_compact_values[tile[1]]])
end
tiles = new_tiles

red_tiles_list = []
red_tiles_set = Set.new
green_tiles_set = Set.new

def connect_in_green_tiles(set, a, b)
  x1, y1 = a
  x2, y2 = b

  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort

  xdiff = x1 == x2 ? 0 : 1
  ydiff = y1 == y2 ? 0 : 1

  x1 += xdiff
  y1 += ydiff

  while x1 != x2 || y1 != y2
    set.add([x1, y1])

    x1 += xdiff
    y1 += ydiff
  end
end

min_x = 1_000_000_000
max_x = -1_000_000_000
min_y = 1_000_000_000
max_y = -1_000_000_000

tiles.each do |tile|
  x, y = tile

  min_x = [x, min_x].min
  max_x = [x, max_x].max
  min_y = [y, min_y].min
  max_y = [y, max_y].max

  red_tiles_set.add(tile)
  red_tiles_list.push(tile)
end

red_tiles_list.each.with_index do |red_tile, idx|
  prev_red_tile = red_tiles_list[(idx - 1) % red_tiles_list.size]

  connect_in_green_tiles(green_tiles_set, red_tile, prev_red_tile)
end

min_x -= 1
max_x += 1
min_y -= 1
max_y += 1

blue_tiles_set = Set.new

to_paint_blue = [[min_x, min_y]]

while to_paint_blue.size > 0
  x, y = to_paint_blue.shift
  next if x < min_x || x > max_x || y < min_y || y > max_y

  next if red_tiles_set.include?([x, y]) || green_tiles_set.include?([x, y]) || blue_tiles_set.include?([x, y])

  blue_tiles_set.add([x, y])

  to_paint_blue.push([x + 1, y])
  to_paint_blue.push([x - 1, y])
  to_paint_blue.push([x, y + 1])
  to_paint_blue.push([x, y - 1])
end

def any_blue?(blue_tiles_set, tile1, tile2)
  x1, y1 = tile1
  x2, y2 = tile2

  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort

  (x1..x2).each do |x|
    (y1..y2).each do |y|
      if blue_tiles_set.include?([x, y])
        return true
      end
    end
  end

  false
end

largest_area = 0

red_tiles_list.each.with_index do |tile1, idx1|
  red_tiles_list.each.with_index do |tile2, idx2|
    next if idx1 <= idx2

    x1, y1 = tile1
    x2, y2 = tile2

    x1 = x_original_values[x1]
    y1 = y_original_values[y1]
    x2 = x_original_values[x2]
    y2 = y_original_values[y2]

    area = square_area([x1, y1], [x2, y2])
    next if largest_area >= area

    next if any_blue?(blue_tiles_set, tile1, tile2)

    largest_area = area
  end
end

p largest_area
