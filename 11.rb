require 'set'

input = File.read('11.input').split("\n")

# problem 1

devices = {}

input.each do |line|
  name, outputs = line.split(': ')

  devices[name] = { 'outputs' => outputs.split(' ') }
end

def search(devices, from, goal, visited)
  return 1 if from == goal

  return visited[from] if !visited[from].nil?

  from_device = devices[from]
  return 0 if from_device.nil?

  visited[from] = from_device['outputs'].map { |to| search(devices, to, goal, visited) } .sum
end

p search(devices, 'you', 'out', {})

# problem 2

svr_to_fft =  search(devices, 'svr', 'fft', {})
svr_to_dac =  search(devices, 'svr', 'dac', {})
fft_to_dac =  search(devices, 'fft', 'dac', {})
dac_to_fft =  search(devices, 'dac', 'fft', {})
dac_to_out =  search(devices, 'dac', 'out', {})
fft_to_out =  search(devices, 'fft', 'out', {})

p svr_to_fft * fft_to_dac * dac_to_out + svr_to_dac * dac_to_fft * fft_to_out
