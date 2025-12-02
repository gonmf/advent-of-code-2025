input = File.read('02.input')

# problem 1

total_invalid = 0
id_pairs = input.split(',')

id_pairs.each do |id_pair|
  start, finish = id_pair.split('-')

  (start.to_i..finish.to_i).each do |id|
    str = id.to_s
    next if (str.size % 2) == 1

    half = str[0...(str.size / 2)]

    total_invalid += id if str.end_with?(half)
  end
end

p total_invalid

# problem 2

def is_invalid(str)
  div = 2

  while div < 11 && str.size >= div
    if (str.size % div) == 0
      part = str[0, str.size / div]

      if str == (part * div)
        return true
      end
    end

    div += 1
  end

  false
end

total_invalid = 0
id_pairs = input.split(',')

id_pairs.each do |id_pair|
  start, finish = id_pair.split('-')

  (start.to_i..finish.to_i).each do |id|
    str = id.to_s

    total_invalid += id if is_invalid(str)
  end
end

p total_invalid
