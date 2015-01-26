Shindo.tests('HP::DNS | records collection', ['hp', 'dns', 'records']) do

  @domain = HP[:dns].domains.create({:name => 'www.fogtest.com.', :email => 'test@fogtest.com'})

  attributes = {:domain_id => @domain.id, :name => 'www.fogtest.com.', :type => 'A', :data => '15.185.172.152'}
  collection_tests(@domain.records, attributes, true)

  @domain.destroy
end
