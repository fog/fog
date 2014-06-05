module Fog
  module Rackspace
    class Monitoring
      class Real
        def list_data_points(entity_id, check_id, metric_name, options)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}/metrics/#{metric_name}/plot",
            :query    => options
          )
        end
      end

      class Mock
        def list_data_points(entity_id, check_id, metric_name, options)
          if entity_id == -1 || check_id == -1 || metric_name == -1 || options == -1
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "values"  => [],
            "metadata"=> {
              "count"       =>0,
              "limit"       =>nil,
              "marker"      =>nil,
              "next_marker" =>nil,
              "next_href"   =>nil
            }
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "slknbnsodb9830unvnve",
            "X-LB"                  => "ord1-maas-prod-api1",
            "Content-Type"          => "application/json; charset=UTF-8",
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
