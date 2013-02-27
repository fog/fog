module Fog
  module HP
    module DNS
      class Real
        # List all flavors (IDs and names only)

        def list_records
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => 'records',
          )
        end

      end

      class Mock
        def list_records
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
             "records" => [
               {
                 "id" => "2e32e609-3a4f-45ba-bdef-e50eacd345ad",
                 "name" => "www.example.com.",
                 "type" => "A",
                 "ttl" => 3600,
                 "created_at" => "2012-11-02T19:56:26.000000",
                 "updated_at" => "2012-11-04T13:22:36.000000",
                 "data" => "15.185.172.153",
                 "domain_id" => "89acac79-38e7-497d-807c-a011e1310438",
                 "tenant_id" => null,
                 "priority" => null,
                 "version" => 1,
               },
               {
                 "id" => "8e9ecf3e-fb92-4a3a-a8ae-7596f167bea3",
                 "name" => "host1.example.com.",
                 "type" => "A",
                 "ttl" => 3600,
                 "created_at" => "2012-11-04T13:57:50.000000",
                 "updated_at" => null,
                 "data" => "15.185.172.154",
                 "domain_id" => "89acac79-38e7-497d-807c-a011e1310438",
                 "tenant_id" => null,
                 "priority" => null,
                 "version" => 1
               }
             ]
           }
          response
        end

      end
    end
  end
end