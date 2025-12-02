input = File.read('01.input')

# problem 1

dial = 50
zeroes = 0

input.split("\n").each do |line|
  is_left = line[0] == 'L'
  value = line[1..-1].to_i

  dial = (dial + (is_left ? -value : value)) % 100
  zeroes += 1 if dial == 0
end

p zeroes

# problem 2

dial = 50
zeroes = 0

input.split("\n").each do |line|
  is_left = line[0] == 'L'
  value = line[1..-1].to_i
  diff = is_left ? -1 : 1

  while value > 0
    value -= 1
    dial += diff

    if dial == -1
      dial = 99
    elsif dial == 100
      dial = 0
    end

    zeroes += 1 if dial == 0
  end
end

p zeroes
