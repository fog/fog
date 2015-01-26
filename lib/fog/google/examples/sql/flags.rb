def test
  connection = Fog::Google::SQL.new

  puts 'Listing all Flags...'
  puts '--------------------'
  connection.flags
end
