module Fog
  module DNS
    class Dynect
      class Real

        # Update a zone
        #
        # ==== Parameters
        # * zone<~String> - name or id of zone
        # * options<~Hash>:
        #   * freeze<~Boolean> - causes zone to become frozen
        #   * publish<~Boolean> - causes all pending changes to be pushed to nameservers
        #   * thaw<~Boolean> - causes zone to cease being frozen

        def put_zone(zone, options = {})
          request(
            :body     => MultiJson.encode(options),
            :expects  => 200,
            :method   => :put,
            :path     => 'Zone/' << zone
          )
        end
      end

      class Mock
        def put_zone(zone, options = {})
          raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][zone]

          raise ArgumentError unless options.size == 1

          response = Excon::Response.new
          response.status = 200

          data = {}

          if options['freeze']
            zone['frozen'] = true
            info = "freeze: Your zone is now frozen"
          elsif options['publish']
            zone[:changes] = {}
            zone[:records_to_delete].each do |record|
              zone[:records][record[:type]].delete_if { |r| r[:fqdn] == record[:fqdn] && r[:record_id] == record[:record_id] }
            end
            zone[:records_to_delete] = []
            data = {
              "zone_type" => zone[:zone_type],
              "serial_style" => zone[:serial_style],
              "serial" => zone[:serial] += 1,
              "zone" => zone[:zone]
            }
            info = "publish: #{zone[:zone]} published"
          elsif options['thaw']
            zone[:frozen] = false
            info = "thaw: Your zone is now thawed, you may edit normally"
          else
            raise ArgumentError
          end

          response.body = {
            "status" => "success",
            "data" => data,
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "INFO" => info,
              "SOURCE"=>"BLL",
              "ERR_CD"=>nil,
              "LVL"=>"INFO"
            }]
          }

          response
        end
      end
    end
  end
end
