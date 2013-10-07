Shindo.tests('HP::DNS | domain model', ['hp', 'dns', 'domain']) do

  attributes = {:name => 'www.fogtest.com.', :email => 'test@fogtest.com'}
  model_tests(HP[:dns].domains, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'www.fogtest.com.', :email => 'test@fogtest.com', :ttl => 3600}
      @domain = HP[:dns].domains.create(attributes)
      !@domain.id.nil?
    end

    tests('Update via #save').succeeds do
      @domain.email = 'update@fogtest.com'
      @domain.save
    end

    tests('#destroy').succeeds do
      @domain.destroy
    end

  end

end
