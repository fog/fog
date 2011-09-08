Shindo.tests('Fog::DNS[:rackspace] | DNS requests', ['rackspace', 'dns']) do

  @service = Fog::DNS[:rackspace]

  tests('success on simple domain') do
    domain_tests(@service, {:name => 'basictestdomain.com', :email => 'hostmaster@basictestdomain.com', :records => [{:ttl => 300, :name => 'basictestdomain.com', :type => 'A', :data => '192.168.1.1'}]}) do

      tests('list_domains').formats(LIST_DOMAIN_FORMAT) do
        @service.list_domains.body
      end

      tests("list_domains :limit => 5, :offset => 10, :domain => #{@domain_details.first['name']} --> All possible attributes").formats(LIST_DOMAIN_FORMAT) do
        @service.list_domains(:limit => 5, :offset => 10, :domain => @domain_details.first['name']).body
      end

      tests("list_domain_details('#{@domain_id}')").formats(LIST_DOMAIN_DETAILS_WITH_RECORDS) do
        @service.list_domain_details(@domain_id).body
      end

      tests("modify_domain('#{@domain_id}', :ttl => 500, :comment => 'woot', :email => 'randomemail@randomhost.com')").succeeds do
        response = @service.modify_domain @domain_id, :ttl => 500, :comment => 'woot', :email => 'randomemail@randomhost.com'
        wait_for @service, response
      end
    end
  end

  tests('success for domain with multiple records') do
    domain_tests(@service,
      {
        :name => 'testdomainwithmultiplerecords.com',
        :email => 'hostmaster@testdomainwithmultiplerecords.com',
        :records =>
          [
            {
              :ttl => 300,
              :name => 'testdomainwithmultiplerecords.com',
              :type => 'A',
              :data => '192.168.1.1'
            },
            {
              :ttl => 3600,
              :name => 'testdomainwithmultiplerecords.com',
              :type => 'MX',
              :data => 'mx.testdomainwithmultiplerecords.com',
              :priority => 10
            }
          ]
     })
  end

  tests('success for multiple domains') do
    domains_tests(@service,
      [
        {:name => 'basictestdomain1.com', :email => 'hostmaster@basictestdomain1.com', :records => [{:ttl => 300, :name =>'basictestdomain1.com', :type => 'A', :data => '192.168.1.1'}]},
        {:name => 'basictestdomain2.com', :email => 'hostmaster@basictestdomain2.com', :records => [{:ttl => 300, :name =>'basictestdomain2.com', :type => 'A', :data => '192.168.1.1'}]}
      ])
  end

  tests('success for domain with subdomain') do
    domains_tests(@service,
      [
        {:name => 'basictestdomain.com', :email => 'hostmaster@basictestdomain.com', :records => [{:ttl => 300, :name =>'basictestdomain.com', :type => 'A', :data => '192.168.1.1'}]},
        {:name => 'subdomain.basictestdomain.com', :email => 'hostmaster@subdomain.basictestdomain.com', :records => [{:ttl => 300, :name =>'subdomain.basictestdomain.com', :type => 'A', :data => '192.168.1.1'}]}
      ], true) do

      @root_domain_id = @domain_details.find { |domain| domain['name'] == 'basictestdomain.com' }['id']

      tests("list_domain_details('#{@root_domain_id}', :show_records => false, :show_subdomains => false)") do
        response = @service.list_domain_details(@root_domain_id, :show_records => false, :show_subdomains => false)

        formats(LIST_DOMAIN_DETAILS_WITHOUT_RECORDS_AND_SUBDOMAINS_FORMAT) { response.body }
        returns(nil) { response.body['recordsList'] }
        returns(nil) { response.body['subdomains'] }
      end

      tests("list_domain_details('#{@root_domain_id}', :show_records => true, :show_subdomains => true)") do
        response = @service.list_domain_details(@root_domain_id, :show_records => true, :show_subdomains => true)

        formats(LIST_DOMAIN_DETAILS_WITH_RECORDS_AND_SUBDOMAINS_FORMAT) { response.body }
        returns(false) { response.body['recordsList'].nil? }
        returns(false) { response.body['subdomains'].nil? }
      end

      tests("list_subdomains('#{@root_domain_id}')").formats(LIST_SUBDOMAINS_FORMAT) do
        @service.list_subdomains(@root_domain_id).body
      end

      tests("remove_domain('#{@root_domain_id}', :delete_subdomains => true)") do
        wait_for @service, @service.remove_domain(@root_domain_id, :delete_subdomains => true)

        test('domain and subdomains were really deleted') do
          (@service.list_domains.body['domains'].collect { |domain| domain['name'] } & ['basictestdomain.com', 'subdomain.basictestdomain.com']).empty?
        end
      end
    end
  end

  tests( 'failure') do

    tests('create_domain(invalid)').raises(Fog::Rackspace::Errors::BadRequest) do
      wait_for @service, @service.create_domains([{:name => 'badtestdomain.com', :email => '', :records => [{:ttl => 300, :name => 'badtestdomain.com', :type => 'A', :data => '192.168.1.1'}]}])
    end

    tests('list_domains :limit => 5, :offset => 8').raises(Fog::Rackspace::Errors::BadRequest) do
      @service.list_domains :limit => 5, :offset => 8
    end

    tests('list_domain_details 34335353').raises(Fog::Rackspace::Errors::NotFound) do
      @service.list_domain_details 34335353
    end

    #tests('create_domains(#{domains})').raises(Fog::Rackspace::Errors::Conflict) do
    #  wait_for @service.create_domains(domains)
    #end
    #tests('remove_domain(34343435)').raises(Fog::DNS::Rackspace::DeleteFault) do
    #  @service.remove_domain 34343435
    #end
  end
end
