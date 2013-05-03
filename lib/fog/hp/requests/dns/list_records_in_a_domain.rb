module Fog
  module HP
    class DNS
      class Real
        def list_records_in_a_domain(domain_id)
          request(
              :expects => [200],
              :method  => 'GET',
              :path    => "domains/#{domain_id}/records"
          )
        end

      end
      class Mock
        def list_records_in_a_domain(domain_id)
          response = Excon::Response.new
          if records = find_domain(domain_id)
            response.status = 200
            response.body   = records_for_domain(domain_id)
          else
            raise Fog::HP::DNS::NotFound
          end
          response
        end

        def find_domain(domain_id)
          list_domains.body['domains'].detect { |_| _['id'] == domain_id }
        end

        def records_for_domain(domain_id)

          data = {
            "records" => [
              {
                "id"         => "2e32e609-3a4f-45ba-bdef-e50eacd345ad",
                "name"       => "www.example.com.",
                "type"       => "A",
                "ttl"        => 3600,
                "created_at" => "2012-11-02T19:56:26.000000",
                "updated_at" => "2012-11-04T13:22:36.000000",
                "data"       => "15.185.172.153",
                "domain_id"  => "89acac79-38e7-497d-807c-a011e1310438",
                "tenant_id"  => nil,
                "priority"   => nil,
                "version"    => 1,
              },
              {
                "id"         => "8e9ecf3e-fb92-4a3a-a8ae-7596f167bea3",
                "name"       => "host1.example.com.",
                "type"       => "A",
                "ttl"        => 3600,
                "created_at" => "2012-11-04T13:57:50.000000",
                "updated_at" => nil,
                "data"       => "15.185.172.154",
                "domain_id"  => "89acac79-38e7-497d-807c-a011e1310438",
                "tenant_id"  => nil,
                "priority"   => nil,
                "version"    => 1
              }
            ]
          }

          if domain_id == list_domains.body["domains"].first["id"]
            data
          else
            {
              "records" => []
            }
          end

        end

      end

    end
  end
end
