Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do
  tests "success" do
    tests "start api session" do
      response = Dynect[:dns].session
      returns(true) { response.body['Auth-Token'] =~ /.+=$/ && true }
      returns(true) { response.body['API-Version'] == "2.3.1" }
      returns(true) { response.status == 200 }
    end

    tests "list zones" do
      response = Dynect[:dns].zones
      returns(true) { response.body['zones'].first =~ /\.com/ && true }
      returns(true) { response.status == 200 }
    end

    tests "get zone" do
      first_zone_name = Dynect[:dns].zones.body['zones'].first
      response = Dynect[:dns].zone(first_zone_name)
      returns(true) { response.body['zone'] == first_zone_name }
      returns(true) { response.body['serial'] > 0 }
      returns(true) { response.body['zone_type'] == "Primary" }
      returns(true) { response.body['serial_style'] == "increment" }
    end

    tests "list records"

    tests "create record"
    tests "delete record"
    tests "update record"
    tests "list jobs"
  end
end
