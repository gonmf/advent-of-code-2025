input = File.read('03.input')

# problem 1

def max_pair(bateries)
  max = 0

  bateries.each.with_index do |b1, v1|
    bateries.each.with_index do |b2, v2|
      next if v1 >= v2

      max = [max, b1 * 10 + b2].max
    end
  end

  max
end

total = 0

input.split("\n").each do |bank|
  bateries = bank.split('').map(&:to_i)

  max_joltage = max_pair(bateries)

  total += max_joltage
end

p total

# problem 2

def find_max(bateries, size, memo)
  memo[[bateries.size, size].join(',')] ||= begin
    if bateries.size == size
      return bateries.map(&:to_s).join().to_i
    end
    if size == 1
      return bateries.max
    end

    max = 0

    bateries.each.with_index do |b1, v1|
      value = "#{b1}#{find_max(bateries[v1 + 1, bateries.size], size - 1, memo)}".to_i
      max = [max, value].max
    end

    max
  end
end

total = 0

input.split("\n").each do |bank|
  bateries = bank.split('').map(&:to_i)

  total += find_max(bateries, 12, {})
end

p total
