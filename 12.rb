require 'set'

input = File.read('12.input').split("\n")

# problem 1

presents = []
reading_present = false
present_buffer = []
regions = []

input.each do |line|
  next if line == ''

  if line.end_with?(':')
    if reading_present && present_buffer.size > 0
      presents.push({
        'variants' => [present_buffer.map { |l| l.map { |v| v == '#' ? 1 : 0 } }]
      })
      present_buffer = []
    end

    reading_present = true
    next
  end
  if line.include?('x')
    if reading_present
      if present_buffer.size > 0
        presents.push({
          'variants' => [present_buffer.map { |l| l.map { |v| v == '#' ? 1 : 0 } }]
        })
        present_buffer = []
      end
      reading_present = false
    end

    dims, reqs = line.split(': ')
    width, height = dims.split('x').map(&:to_i)
    reqs = reqs.split(' ').map(&:to_i)

    regions.push({
      'width' => width,
      'height' => height,
      'reqs' => reqs,
    })
    next
  end

  if reading_present
    present_buffer.push(line.split(''))
  end
end

def flip(m)
  m.reverse
end

def rotate(m)
  m.transpose.map(&:reverse)
end

def expand_present(present)
  flipped = flip(present)
  presents = [present, rotate(present), rotate(rotate(present)), rotate(rotate(rotate(present))),
              flipped, rotate(flipped), rotate(rotate(flipped)), rotate(rotate(rotate(flipped)))]

  presents = presents.map { |p| [p.map { |l| l.join('') }.join(','), p] }
  ids = presents.map { |p| p[0] }.uniq

  ids.map { |id| presents.find { |p| p[0] == id }[1] }
end

def attempt_placement(state, x, y, present)
  state = state.dup

  present.each.with_index do |row, y2|
    row.each.with_index do |v, x2|
      next if v == 0

      tx = x2 + x
      ty = y2 + y
      v = state.dig(ty, tx)

      return nil if v == 1 || v == nil

      state[ty][tx] = 1
    end
  end

  state
end

def search(state, presents_required, presents)
  next_present = presents_required.find_index { |v| v > 0 }
  return true if next_present.nil?

  present = presents[next_present]

  state.each.with_index do |row, y|
    next if y == state.size - 2
    row.each.with_index do |v, x|
      next if x == row.size - 2

      present['variants'].each do |variant|
        new_state = attempt_placement(state, x, y, variant)
        next if new_state.nil?

        presents_required2 = presents_required.dup
        presents_required2[next_present] -= 1
        result = search(new_state, presents_required2, presents)
        return true if result
      end
    end
  end

  false
end

presents.each do |present|
  present['variants'] = expand_present(present['variants'][0])
end

total = 0

regions.each do |region|
  p region

  m = Array.new(region['width']).map { |v| Array.new(region['height'], 0) }

  total += 1 if search(m, region['reqs'], presents)

  exit if total == 3
end

p total
