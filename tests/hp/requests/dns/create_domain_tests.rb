Shindo.tests("HP::DNS | create domain tests", ['hp', 'dns', 'domain']) do

  @create_format = {
    id: String,
    name: String,
    ttl: Integer,
    serial: Integer,
    email: String,
    created_at: String
  }

  tests('success') do
    tests("#create_domain").formats(@create_format) do
      HP[:dns].create_domain("name","joe@blow.com").body
    end
  end
end
