Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do
  tests "success" do
    def zone
      ENV['DYNECT_ZONE']
    end

    def fqdn
      ENV['DYNECT_FQDN']
    end

    tests "start api session" do
      response = Dynect[:dns].session
      returns(true) { response.body['Auth-Token'] =~ /.+=$/ && true }
      returns(true) { response.body['API-Version'] == "2.3.1" }
      returns(true) { response.status == 200 }
    end

    tests "list zones" do
      response = Dynect[:dns].list_zones
      returns(true) { response.body['zones'].first =~ /\.com/ && true }
      returns(true) { response.status == 200 }
    end

    tests "get zone" do
      response = Dynect[:dns].get_zone(zone)
      returns(true) { response.body['zone'] == zone }
      returns(true) { response.body['serial'] > 0 }
      returns(true) { response.body['zone_type'] == "Primary" }
      returns(true) { response.body['serial_style'] == "increment" }
    end

    tests "list records" do
      responses = Dynect[:dns].list_any_records(zone, fqdn)
      returns(3) { responses.size }
      returns(30) { responses.map(&:body).first['ttl'] }
    end

    tests "list zone nodes" do
      response = Dynect[:dns].node_list(zone)
      returns(zone) { response.body.first }
    end

    tests "model" do
      records = Fog::DNS.new(:provider => "Dynect").zones.get(zone).records.all(:nodes => fqdn)
      returns("127.0.0.2") { records.last.value }
    end

    tests "create record"
    tests "delete record"
    tests "update record"
    tests "list jobs"
  end
end
