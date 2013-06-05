Shindo.tests("HP::DNS | get domain tests", ['hp', 'dns', 'domain']) do
  @domain_id = "09494b72-b65b-4297-9efb-187f65a0553e"
  @domain_bad = "09494b72-111-222-333"

  @domain_format = {
      "id" => String,
      "name" => String,
      "ttl" => Integer,
      "serial" =>  Integer,
      "email" => String,
      "created_at" => String
  }

  tests('success') do
    tests("#get_domain(#{ @domain_id})").formats(@domain_format) do
      HP[:dns].get_domain(@domain_id).body['domain']
    end
  end
  tests('failure') do
    tests("#get_domain(#{ @domain_bad})").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].get_domain(@domain_body)
    end

  end

end