module Fog
  module DNS
    class Dynect
      class Real

        # Delete a zone
        #
        # ==== Parameters
        # * zone<~String> - zone to host

        def delete_zone(zone)
          request(
            :expects  => 200,
            :method   => :delete,
            :path     => "Zone/#{zone}"
          )
        end
      end

      class Mock
        def delete_zone(zone)
          self.data[:zones].delete(zone)

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "success",
            "data" => {},
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "ERR_CD" => '',
              "INFO" => '',
              "LVL" => '',
              "SOURCE" => ''
            }]
          }
          response
        end
      end
    end
  end
end
