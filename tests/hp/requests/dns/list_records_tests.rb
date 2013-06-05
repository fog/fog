Shindo.tests("HP::DNS | list records tests", ['hp', 'dns', 'records']) do
  @domain_id = "09494b72-b65b-4297-9efb-187f65a0553e"
  @domain2 = "89acac79-38e7-497d-807c-a011e1310438"
  @domain_bad = "09494b72-111-222-333"
  tests('success') do
    tests("#list_records_in_a_domain(#{@domain_id})").succeeds do
      HP[:dns].list_records_in_a_domain(@domain_id)
    end
    tests("#list_records_in_a_domain(#{@domain2})").returns(true) do
      HP[:dns].list_records_in_a_domain(@domain2).body["records"].count == 0
    end

  end
  tests('failure') do
    tests("#list_records_in_a_domain(#{@domain_bad})").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].list_records_in_a_domain(@domain_bad)
    end
  end

end