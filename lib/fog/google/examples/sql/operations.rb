def test
  connection = Fog::Google::SQL.new

  puts 'Create a Instance...'
  puts '--------------------'
  instance = connection.instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  instance.wait_for { ready? }

  puts 'Delete the Instance...'
  puts '----------------------'
  operation = instance.destroy

  puts 'Get the Operation...'
  puts '--------------------'
  connection.operations.get(instance.identity, operation.identity)

  puts 'Listing all Operations...'
  puts '-------------------------'
  connection.operations.all(instance.identity)
end
