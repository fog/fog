Shindo.tests('Fog::DNS[:rackspace] | dns records requests', ['rackspace', 'dns']) do

  pending if Fog.mocking?

  domain_tests(Fog::DNS[:rackspace], {:name => 'basictestdomain.com', :email => 'hostmaster@basictestdomain.com', :records => [{:ttl => 300, :name => 'basictestdomain.com', :type => 'A', :data => '192.168.1.1'}]}) do

    tests('success on single record') do

      tests("list_records(#{@domain_id})").formats(RECORD_LIST_FORMAT) do
        Fog::DNS[:rackspace].list_records(@domain_id).body
      end

      tests("add_records(#{@domain_id}, [{ :name => 'test1.basictestdomain.com', :type => 'A', :data => '192.168.2.1'}])").formats(RECORD_LIST_FORMAT) do
        response = wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].add_records(@domain_id, [{ :name => 'test1.basictestdomain.com', :type => 'A', :data => '192.168.2.1'}])
        @record_id = response.body['records'].first['id']
        response.body
      end

      tests("list_record_details(#{@domain_id}, #{@record_id})").formats(RECORD_FORMAT) do
        Fog::DNS[:rackspace].list_record_details(@domain_id, @record_id).body
      end

      tests("modify_record(#{@domain_id}, #{@record_id}, { :ttl => 500, :name => 'test2.basictestdomain.com', :data => '192.168.3.1' })").succeeds do
        wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].modify_record(@domain_id, @record_id, { :ttl => 500, :name => 'test2.basictestdomain.com', :data => '192.168.3.1' })
      end

      tests("remove_record(#{@domain_id}, #{@record_id})").succeeds do
        wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].remove_record(@domain_id, @record_id)
      end
    end

    tests('success on multiple records') do

      records_attributes =
        [
          { :name => 'test1.basictestdomain.com', :type => 'A', :data => '192.168.2.1'},
          { :name => 'basictestdomain.com', :type => 'MX', :priority => 10, :data => 'mx.basictestdomain.com'}
        ]

      tests("add_records(#{@domain_id}, #{records_attributes})").formats(RECORD_LIST_FORMAT) do
        response = wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].add_records(@domain_id, records_attributes)
        @record_ids = response.body['records'].collect { |record| record['id'] }
        response.body
      end

      tests("remove_records(#{@domain_id}, #{@record_ids})").succeeds do
        wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].remove_records(@domain_id, @record_ids)
      end
    end

    tests( 'failure') do
      tests("list_records('')").raises(ArgumentError) do
        Fog::DNS[:rackspace].list_records('')
      end

      tests("list_records('abc')").raises(Fog::Rackspace::Errors::NotFound) do
        Fog::DNS[:rackspace].list_records('abc')
      end

      tests("list_record_details(#{@domain_id}, '')").raises(ArgumentError) do
        Fog::DNS[:rackspace].list_record_details(@domain_id, '')
      end

      tests("list_record_details(#{@domain_id}, 'abc')").raises(Fog::Rackspace::Errors::NotFound) do
        Fog::DNS[:rackspace].list_record_details(@domain_id, 'abc')
      end

      tests("remove_record(#{@domain_id}, '')").raises(ArgumentError) do
        Fog::DNS[:rackspace].remove_record(@domain_id, '')
      end

      tests("remove_record(#{@domain_id}, 'abc')").raises(Fog::Rackspace::Errors::NotFound) do
        Fog::DNS[:rackspace].remove_record(@domain_id, 'abc')
      end

      tests("add_record(#{@domain_id}, [{ :name => '', :type => '', :data => ''}])").raises(Fog::Rackspace::Errors::BadRequest) do
        Fog::DNS[:rackspace].add_records(@domain_id, [{ :name => '', :type => '', :data => ''}])
      end
    end
  end
end
