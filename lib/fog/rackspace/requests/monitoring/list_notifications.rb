module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_notifications(options={})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "notifications",
            :query    => options
          )
        end
      end

      class Mock
        def list_notifications(options={})
          account_id = Fog::Mock.random_numbers(6).to_s
          server_id = Fog::Rackspace::MockData.uuid
          entity_id = Fog::Mock.random_letters(10)
          entity_label = Fog::Mock.random_letters(10)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"=> [
              {
                  "created_at"=>1378783452067,
                  "details"=>{
                      "address"=>"test@test.com"
                  },
                  "id"=>"ntnJN3MQrA",
                  "label"=>"my email update test",
                  "type"=>"email",
                  "updated_at"=>1378784136307
              }
          ],
            "metadata" => {
               "count"       => 1,
               "limit"       => 100,
               "marker"      => nil,
               "next_marker" => nil,
               "next_href"   => nil
            }
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "j23jlk234jl2j34j",
            "X-LB"                  => "dfw1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
          response.remote_ip = Fog::Rackspace::MockData.ipv4_address
          response
        end
      end
    end
  end
end
