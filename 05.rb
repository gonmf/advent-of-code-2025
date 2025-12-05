require 'set'

input = File.read('05.input')

# problem 1

fresh_ranges = []
available_ingredients = []

input.split("\n").each do |line|
  next if line == ''

  if line.include?('-')
    fresh_ranges.push(line.split('-').map(&:to_i))
    next
  end

  available_ingredients.push(line.to_i)
end

total_fresh = 0

available_ingredients.each do |ingredient|
  if fresh_ranges.any? { |range| range[0] <= ingredient && ingredient <= range[1] }
    total_fresh += 1
  end
end

p total_fresh

# problem 2

any_modified = true

while any_modified
  new_ranges = []
  any_modified = false

  fresh_ranges.each do |range|
    if new_ranges.any? { |r| r[0] <= range[0] && r[1] >= range[1] }
      next
    end

    overlap = new_ranges.find { |r| r[0] >= range[0] && r[1] <= range[1] }
    if overlap
      overlap[0] = range[0]
      overlap[1] = range[1]
      next
    end

    overlap = new_ranges.find { |r| r[0] <= range[0] && r[1] < range[1] && r[1] >= range[0] }
    if overlap
      overlap[1] = range[1]
      any_modified = true
      next
    end

    overlap = new_ranges.find { |r| r[0] >= range[0] && r[1] > range[1] && r[0] <= range[1] }
    if overlap
      overlap[0] = range[0]
      any_modified = true
      next
    end

    new_ranges.push([range[0], range[1]])
  end

  fresh_ranges = new_ranges
end

p fresh_ranges.map { |r| r[1] - r[0] + 1 }.sum
