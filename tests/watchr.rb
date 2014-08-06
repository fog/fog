ENV['FOG_MOCK'] ||= 'true'
ENV['AUTOTEST'] = 'true'
ENV['WATCHR']   = '1'
require 'pry-nav'

def file2shindo(file)
  result = file.sub('lib/fog/', 'tests/').gsub(/\.rb$/, '_tests.rb')
end

def run_shindo_test(file)
  binding.pry
  if File.exist? file
    system("shindont #{file}")
  else
    puts "FIXME: No test #{file} [#{Time.now}]"
  end
end

watch( 'tests/.*_tests\.rb' ) do |md|
  run_shindo_test(md[0])
end
watch( 'lib/.*\.rb' ) do |md|
  run_shindo_test(file2shindo(md[0]))
end
