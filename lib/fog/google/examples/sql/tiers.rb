def test
  connection = Fog::Google::SQL.new

  puts 'Listing all Tiers...'
  puts '--------------------'
  connection.tiers
end
