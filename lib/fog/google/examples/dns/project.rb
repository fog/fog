def test
  connection = Fog::DNS::Google.new

  puts 'Get the Project limits...'
  puts '-------------------------'
  connection.projects.get(Fog::DNS[:google].project)

end
