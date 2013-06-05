module Fog
  module HP
    class DNS
      class Real
        def create_record(domain_id, name, type, data)

          data = {
              :name=> name,
              :type=> type,
              :data=> data
          }

          request(
              :body    => Fog::JSON.encode(data),
              :expects => 200,
              :method  => 'POST',
              :path    => "domains/#{domain_id}/records"
          )

        end
      end
      class Mock
        def create_record(domain_id, name, type, data)
          response        = Excon::Response.new
          response.status = 200
          data            = {
              :id=>         "2e32e609-3a4f-45ba-bdef-e50eacd345ad",
              :name=>       "www.example.com.",
              :type=>       "A",
              :created_at=> "2012-11-02T19:56:26.366792",
              :updated_at=> null,
              :domain_id=>  "89acac79-38e7-497d-807c-a011e1310438",
              :ttl=>        3600,
              :data=>       "15.185.172.152"
          }
          response.body   = data
          response
          response
        end
      end
    end
  end
end

