Shindo.tests('HP::DNS | domains collection', ['hp', 'dns', 'domains']) do

  attributes = {:name => 'www.fogtest.com.', :email => 'test@fogtest.com', :ttl => 3600}
  collection_tests(HP[:dns].domains, attributes, true)

  tests('success') do

    tests('#all').succeeds do
      HP[:dns].domains.all
    end

  end

end
