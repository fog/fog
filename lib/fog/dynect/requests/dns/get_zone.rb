module Fog
  module DNS
    class Dynect
      class Real

        # Get one or more zones
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * zone<~String> - name of zone to lookup, or omit to return list of zones

        def get_zone(options = {})
          request(
            :expects  => 200,
            :idempotent => true,
            :method   => :get,
            :path     => ['Zone', options['zone']].compact.join('/')
          )
        end
      end

      class Mock
        def get_zone(options = {})
          if options['zone']
            raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][options['zone']]
            data = {
              "zone_type" => zone[:zone_type],
              "serial_style" => zone[:serial_style],
              "serial" => zone[:serial],
              "zone" => zone[:zone]
            }
            info = "get: Your zone, #{zone[:zone]}"
          else
            data = self.data[:zones].collect { |zone, data| "/REST/Zone/#{zone}/" }
            info = "get: Your #{data.size} zones"
          end

          response = Excon::Response.new
          response.status = 200

          response.body = {
            "status" => "success",
            "data" => data,
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "INFO" => info,
              "SOURCE" => "BLL",
              "ERR_CD" => nil,
              "LVL" => "INFO"
            }]
          }

          response
        end
      end
    end
  end
end
