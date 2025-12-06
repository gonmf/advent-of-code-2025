input = File.read('06.input').split("\n")

# problem 1

matrix = []

input.each.with_index do |row, y|
  row.split(' ').each.with_index do |val, x|
    matrix[x] ||= []
    matrix[x][y] = val
  end
end

total = 0

matrix.each do |equation|
  vals = equation[0, equation.size - 1].map(&:to_i)

  total += vals.inject(equation.last.to_sym)
end

p total

# problem 2

lines = input.map { |l| (l + '    ').split('') }
start = 0
rows = []

lines[0].each.with_index do |c, x|
  if lines.all? { |l| l[x] == ' ' }
    if !start.nil?
      row = lines.map { |l| l[start, x - start].join('') }
      rows.push(row)
      start = x + 1
      next
    end
  end
end

total = 0

rows.each do |row|
  oper = row.last.strip
  next if oper == ''

  row = row[0, row.size - 1]

  values = []

  row.each do |rw|
    rw.split('').each.with_index do |v, ps|
      values[ps] ||= ''
      values[ps] += v
    end
  end

  total += values.map { |v| v.strip.to_i }.inject(oper.to_sym)
end

p total
