Shindo.tests('HP::DNS | record model', ['hp', 'dns', 'record']) do

  @domain = HP[:dns].domains.create({:name => 'www.fogtest.com.', :email => 'test@fogtest.com'})

  attributes = {:domain_id => @domain.id, :name => 'www.fogtest.com.', :type => 'A', :data => '15.185.100.152'}
  model_tests(@domain.records, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:domain_id => @domain.id, :name => 'www.fogtest.com.', :type => 'A', :data => '15.185.200.152', :description => 'test record'}
      @record = HP[:dns].records.create(attributes)
      !@record.id.nil?
    end

    tests('Update via #save').succeeds do
      @record.name = 'www.fogupdate.com.'
      @record.description = 'desc for record'
      @record.save
    end

    tests('#destroy').succeeds do
      @record.destroy
    end

  end

  @domain.destroy
end
