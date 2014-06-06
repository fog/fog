Shindo.tests('Fog::DNS[:rackspace] | DNS requests', ['rackspace', 'dns']) do

  pending if Fog.mocking?
  domain_name = uniq_id + '.com'

  tests('success on simple domain') do
    domain_tests(Fog::DNS[:rackspace], {:name => domain_name, :email => 'hostmaster@' + domain_name, :records => [{:ttl => 300, :name => domain_name, :type => 'A', :data => '192.168.1.1'}]}) do

      tests('list_domains').formats(LIST_DOMAIN_FORMAT.reject {|key,value| key == 'links'}) do
        Fog::DNS[:rackspace].list_domains.body
      end

      tests("list_domains :limit => 5, :offset => 10, :domain => #{@domain_details.first['name']} --> All possible attributes").formats(LIST_DOMAIN_FORMAT) do
        Fog::DNS[:rackspace].list_domains(:limit => 5, :offset => 10, :domain => @domain_details.first['name']).body
      end

      tests("list_domain_details('#{@domain_id}')").formats(LIST_DOMAIN_DETAILS_WITH_RECORDS) do
        Fog::DNS[:rackspace].list_domain_details(@domain_id).body
      end

      tests("modify_domain('#{@domain_id}', :ttl => 500, :comment => 'woot', :email => 'randomemail@randomhost.com')").succeeds do
        response = Fog::DNS[:rackspace].modify_domain @domain_id, :ttl => 500, :comment => 'woot', :email => 'randomemail@randomhost.com'
        wait_for Fog::DNS[:rackspace], response
      end
    end
  end

  tests('success for domain with multiple records') do
    domain_tests(Fog::DNS[:rackspace],
      {
        :name => domain_name,
        :email => 'hostmaster@' + domain_name,
        :records =>
          [
            {
              :ttl => 300,
              :name => domain_name,
              :type => 'A',
              :data => '192.168.1.1'
            },
            {
              :ttl => 3600,
              :name => domain_name,
              :type => 'MX',
              :data => 'mx.' + domain_name,
              :priority => 10
            }
          ]
     })
  end

  tests('success for multiple domains') do
    domain1_name = uniq_id + '-1.com'
    domain2_name = uniq_id + '-2.com'

    domains_tests(Fog::DNS[:rackspace],
      [
        {:name => domain1_name, :email => 'hostmaster@' + domain1_name, :records => [{:ttl => 300, :name => domain1_name, :type => 'A', :data => '192.168.1.1'}]},
        {:name => domain2_name, :email => 'hostmaster@' + domain2_name, :records => [{:ttl => 300, :name => domain2_name, :type => 'A', :data => '192.168.1.1'}]}
      ])
  end

  tests('success for domain with subdomain') do
    domains_tests(Fog::DNS[:rackspace],
      [
        {:name => domain_name, :email => 'hostmaster@' + domain_name, :records => [{:ttl => 300, :name => domain_name, :type => 'A', :data => '192.168.1.1'}]},
        {:name => 'subdomain.' + domain_name, :email => 'hostmaster@subdomain.' + domain_name, :records => [{:ttl => 300, :name =>'subdomain.' + domain_name, :type => 'A', :data => '192.168.1.1'}]}
      ], true) do

      @root_domain_id = @domain_details.find { |domain| domain['name'] == domain_name }['id']

      tests("list_domain_details('#{@root_domain_id}', :show_records => false, :show_subdomains => false)") do
        response = Fog::DNS[:rackspace].list_domain_details(@root_domain_id, :show_records => false, :show_subdomains => false)

        formats(LIST_DOMAIN_DETAILS_WITHOUT_RECORDS_AND_SUBDOMAINS_FORMAT) { response.body }
        returns(nil) { response.body['recordsList'] }
        returns(nil) { response.body['subdomains'] }
      end

      tests("list_domain_details('#{@root_domain_id}', :show_records => true, :show_subdomains => true)") do
        response = Fog::DNS[:rackspace].list_domain_details(@root_domain_id, :show_records => true, :show_subdomains => true)

        formats(LIST_DOMAIN_DETAILS_WITH_RECORDS_AND_SUBDOMAINS_FORMAT) { response.body }
        returns(false) { response.body['recordsList'].nil? }
        returns(false) { response.body['subdomains'].nil? }
      end

      tests("list_subdomains('#{@root_domain_id}')").formats(LIST_SUBDOMAINS_FORMAT) do
        Fog::DNS[:rackspace].list_subdomains(@root_domain_id).body
      end

      tests("remove_domain('#{@root_domain_id}', :delete_subdomains => true)") do
        wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].remove_domain(@root_domain_id, :delete_subdomains => true)

        test('domain and subdomains were really deleted') do
          (Fog::DNS[:rackspace].list_domains.body['domains'].map { |domain| domain['name'] } & [domain_name, 'subdomain.' + domain_name]).empty?
        end
      end
    end
  end

  tests( 'failure') do

    tests('create_domain(invalid)').returns('ERROR') do
      response = wait_for Fog::DNS[:rackspace], Fog::DNS[:rackspace].create_domains([{:name => 'badtestdomain.com', :email => '', :records => [{:ttl => 300, :name => 'badtestdomain.com', :type => 'A', :data => '192.168.1.1'}]}])

      response.body['status']
    end

    tests('list_domains :limit => 5, :offset => 8').raises(Fog::Rackspace::Errors::BadRequest) do
      Fog::DNS[:rackspace].list_domains :limit => 5, :offset => 8
    end

    tests('list_domain_details 34335353').raises(Fog::DNS::Rackspace::NotFound) do
      Fog::DNS[:rackspace].list_domain_details 34335353
    end

    #tests('create_domains(#{domains})').raises(Fog::Rackspace::Errors::Conflict) do
    #  wait_for Fog::DNS[:rackspace].create_domains(domains)
    #end
    #tests('remove_domain(34343435)').raises(Fog::DNS::Rackspace::DeleteFault) do
    #  Fog::DNS[:rackspace].remove_domain 34343435
    #end
  end
end
