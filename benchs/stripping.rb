require 'rubygems'
require 'benchwarmer'

COUNT = 1_000_000
data = "Content-Length: 100\r\n"
Benchmark.bmbm(25) do |bench|
  bench.report('chomp') do
    COUNT.times do
      data.chomp
    end
  end
  bench.report('chop') do
    COUNT.times do
      data.chop
    end
  end
  bench.report('strip') do
    COUNT.times do
      data.strip
    end
  end
  bench.report('index') do
    COUNT.times do
      data[0..-3]
    end
  end
end
