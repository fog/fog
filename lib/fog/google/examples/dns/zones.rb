def test
  connection = Fog::DNS::Google.new

  puts 'Create a Zone...'
  puts '----------------'
  zone = connection.zones.create(name: 'mytestdomain', domain: 'example.org.', description: 'This is my test domain')

  puts 'List all Zones...'
  puts '-----------------'
  connection.zones.all

  puts 'Get the Zone...'
  puts '---------------'
  zone = connection.zones.get(zone.id)

  puts 'Create an "A" Record...'
  puts '-----------------------'
  record = zone.records.create(name: 'test.example.org.', type: 'A', ttl: 3600, rrdatas: ['192.168.1.1'])

  puts 'Get the Zone Resource Record Sets...'
  puts '------------------------------------'
  zone.records

  puts 'Get the Record...'
  puts '-----------------'
  record = connection.records(zone: zone).get(name: 'test.example.org.', type: 'A')

  puts 'Modify the "A" Record...'
  puts '------------------------'
  record.modify(ttl: 2600)

  puts 'Delete the "A" Record...'
  puts '------------------------'
  record.destroy

  puts 'Get the Zone Changes...'
  puts '-----------------------'
  zone.changes

  puts 'Delete the Zone...'
  puts '------------------'
  zone.destroy
end
