require 'benchmark'
$LOAD_PATH << File.dirname(__FILE__) + '/../lib'

def time_in_fork(&block)
  read, write = IO.pipe
  Process.fork do
    write.puts Benchmark.realtime{ block.call }
  end
  Process.wait
  write.close
  read.read.tap do
    read.close
  end
end

class Array
  def avg
    map(&:to_f).inject(:+) / size
  end
end

def report(label, n = 10, &block)
  puts label
  puts "%.4f" % n.times.map{ time_in_fork &block }.avg
  puts
end

N = 10

report("require fog:", N)             { require 'fog' }
report("require fog/aws:", N)         { require 'fog/aws' }
