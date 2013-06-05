Shindo.tests("HP::DNS | delete domain tests", ['hp', 'dns', 'domain']) do
  @domain_id = "09494b72-b65b-4297-9efb-187f65a0553e"
  @domain_bad = "09494b72-111-222-333"
  tests('success') do
    tests("#delete_domain(#{@domain_id})").succeeds do
      HP[:dns].delete_domain(@domain_id)
    end
  end
  tests('failure') do
    tests("#delete_domain(#{@domain_bad})").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].delete_domain(@domain_bad)
    end
  end

end