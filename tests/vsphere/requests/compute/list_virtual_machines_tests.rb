Shindo.tests('Fog::Compute[:vsphere] | list_virtual_machines request', ['vsphere']) do

  key = 'virtual_machines'

  tests("When listing all machines") do

    response = Fog::Compute[:vsphere].list_virtual_machines

    tests("The response data format ...") do
      test("be a kind of Hash") { response.kind_of? Hash }
      test("have a #{key} key") do
        response.has_key? key
      end
      test("it should be a kind of Array") do
        response[key].kind_of? Array
      end
    end
  end

  tests("When providing an instance_uuid") do

    # pending unless Fog.mock?

    tests("that does exist") do
      uuid = "5032c8a5-9c5e-ba7a-3804-832a03e16381"
      response = Fog::Compute[:vsphere].list_virtual_machines({'instance_uuid' => uuid})

      tests("The response should") do
        test("contain one vm") { response[key].length == 1 }
        test("contain that is an attribute hash") { response[key][0].kind_of? Hash }
        test("find jefftest") { response[key].first['name'] == 'jefftest' }
      end
    end

    tests("that does not exist or is a template") do
      %w{ does-not-exist-and-is-not-a-uuid 50323f93-6835-1178-8b8f-9e2109890e1a }.each do |uuid|
        response = Fog::Compute[:vsphere].list_virtual_machines({'instance_uuid' => uuid})

        tests("The response should") do
          test("be empty") { response[key].empty? }
        end
      end
    end
  end

end
