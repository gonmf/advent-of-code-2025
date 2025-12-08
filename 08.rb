require 'set'

input = File.read('08.input').split("\n")

# problem 1

boxes_list = []

input.sort.each do |box|
  x, y, z = box.split(',').map(&:to_i)

  boxes_list.push([x, y, z])
end

def calc_distance(box1, box2)
  x = box1[0] - box2[0]
  y = box1[1] - box2[1]
  z = box1[2] - box2[2]
  Math.sqrt(x * x + y * y + z * z)
end

sorted_box_pairs_list = []

boxes_list.each.with_index do |box1, idx1|
  boxes_list.each.with_index do |box2, idx2|
    next if idx1 <= idx2

    sorted_box_pairs_list.push({ 'dst' => calc_distance(box1, box2), 'box1' => box1, 'box2' => box2 })
  end
end

target_connections = 1000

sorted_box_pairs_list = sorted_box_pairs_list.sort_by { |p| p['dst'] }

circuits = []

sorted_box_pairs_list[0, target_connections].each do |pair|
  box1 = pair['box1']
  box2 = pair['box2']

  circuit1 = circuits.find { |c| c['boxes'].include?(box1) }
  circuit2 = circuits.find { |c| c['boxes'].include?(box2) }

  if circuit1 && circuit2
    next if circuit1 == circuit2

    circuit2['boxes'].to_a.each do |box|
      circuit1['boxes'].add(box)
    end

    circuits = circuits.select { |c| c != circuit2 }
    next
  end

  if circuit1
    circuit1['boxes'].add(box2)
    next
  end

  if circuit2
    circuit2['boxes'].add(box1)
    next
  end

  circuit = {
    'boxes' => Set.new
  }
  circuit['boxes'].add(box1)
  circuit['boxes'].add(box2)
  circuits.push(circuit)
end

p circuits.map { |c| c['boxes'].size }.sort.last(3).inject(:*)

# problem 2

circuits = []
last_pair = nil

sorted_box_pairs_list.each do |pair|
  if circuits.size == 1 && circuits[0]['boxes'].size == boxes_list.size
    puts last_pair['box1'][0] * last_pair['box2'][0]
    break
  end

  last_pair = pair

  box1 = pair['box1']
  box2 = pair['box2']

  circuit1 = circuits.find { |c| c['boxes'].include?(box1) }
  circuit2 = circuits.find { |c| c['boxes'].include?(box2) }

  if circuit1 && circuit2
    next if circuit1 == circuit2

    circuit2['boxes'].to_a.each do |box|
      circuit1['boxes'].add(box)
    end

    circuits = circuits.select { |c| c != circuit2 }
    next
  end

  if circuit1
    circuit1['boxes'].add(box2)
    next
  end

  if circuit2
    circuit2['boxes'].add(box1)
    next
  end

  circuit = {
    'boxes' => Set.new
  }
  circuit['boxes'].add(box1)
  circuit['boxes'].add(box2)
  circuits.push(circuit)
end
