module Fog
  module HP
    class DNS
      class Real
        # List all flavors (IDs and names only)

        def list_domains
          request(
              :expects => [200],
              :method  => 'GET',
              :path    => 'domains'
          )
        end

      end

      class Mock
        def list_domains
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
              "domains" => [
                {"name" => "domain1.com.", "created_at" => "2012-11-01T20:11:08.000000", "email" => "nsadmin@example.org", "ttl" => 3600, "serial" => 1351800668, "id" => "09494b72-b65b-4297-9efb-187f65a0553e"},
                {"name" => "domain2.com.", "created_at" => "2012-11-01T20:09:48.000000", "email" => "nsadmin@example.org", "ttl" => 3600, "serial" => 1351800588, "id" => "89acac79-38e7-497d-807c-a011e1310438"}
              ]
          }
          response
        end

      end
    end
  end
end
