module Fog
  module Rackspace
    class Monitoring
      class Real

        def delete_alarm(entity_id, alarm_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}/alarms/#{alarm_id}"
          )
        end
      end

      class Mock

        def delete_alarm(entity_id, alarm_id)

          response = Excon::Response.new
          response.status = 204
          response.body = ""
          response.headers = {


          }
          response
        end 
      end
    end
  end
end

