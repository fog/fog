require 'rubygems'
require 'benchwarmer'

COUNT = 1000
data = "Content-Length: 100"
Benchmark.bmbm(25) do |bench|
  bench.report('regex') do
    COUNT.times do
      header = data.match(/(.*):\s(.*)/)
      "#{header[1]}: #{header[2]}"
    end
  end
  bench.report('split') do
    COUNT.times do
      header = data.split(': ')
      "#{header[0]}: #{header[1]}"
    end
  end
end