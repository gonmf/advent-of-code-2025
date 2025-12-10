require 'set'

input = File.read('10.input').split("\n")

# problem 1

def button_press(state, button)
  new_state = state.dup

  button.each do |idx|
    new_state[idx] = state[idx] == 1 ? 0 : 1
  end

  new_state
end

def minimum_presses(state, goal, buttons, presses, max_presses)
  return presses if state == goal
  return nil if presses == max_presses

  result = nil

  buttons.each do |button|
    new_state = button_press(state, button)

    min_presses = minimum_presses(new_state, goal, buttons, presses + 1, max_presses)

    if !min_presses.nil?
      result = result.nil? ? min_presses : [result, min_presses].min
    end
  end

  result
end

total = 0

input.each do |line|
  puts line
  p1, p2 = line.split('] ')

  machine = p1[1, p1.size].split('').map { |v| v == '#' ? 1 : 0 }

  p1, p2 = p2.split(' {')

  buttons = p1.split(' ').map { |p| p[1, p.size - 1].split(',').map(&:to_i) }

  joltage = p2[0, p2.size - 1].split(',').map(&:to_i)

  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 2)
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 3) if min_presses.nil?
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 4) if min_presses.nil?
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 5) if min_presses.nil?
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 6) if min_presses.nil?
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 7) if min_presses.nil?
  min_presses = minimum_presses(machine.map { 0 }, machine, buttons, 0, 8) if min_presses.nil?

  if !min_presses.nil?
    total += min_presses
  end
end

p total

# problem 2

# def button_press2(state, button, goal)
#   state = state.dup

#   button.each do |idx|
#     return nil if state[idx] >= goal[idx]

#     state[idx] += 1
#   end

#   state
# end

# def search_button(btn_i, buttons, state, goal, presses_sum, best_presses)
#   if btn_i == buttons.size
#     if state == goal && best_presses[0] > presses_sum
#       best_presses[0] = presses_sum
#     end
#     return
#   end

#   search_button(btn_i + 1, buttons, state, goal, presses_sum, best_presses)

#   presses = 0
#   button = buttons[btn_i]

#   while true
#     state = button_press2(state, button, goal)
#     break if state.nil?

#     presses += 1
#     break if presses > best_presses[0]

#     search_button(btn_i + 1, buttons, state, goal, presses_sum + presses, best_presses)
#   end
# end

# total = 0

# input.each do |line|
#   p1, p2 = line.split('] ')

#   machine = p1[1, p1.size].split('').map { |v| v == '#' ? 1 : 0 }

#   p1, p2 = p2.split(' {')

#   buttons = p1.split(' ').map { |p| p[1, p.size - 1].split(',').map(&:to_i) }

#   joltage = p2[0, p2.size - 1].split(',').map(&:to_i)

#   result = [999999]
#   search_button(0, buttons, joltage.map { 0 }, joltage, 0, result)
#   total += result[0]
# end

# p total
