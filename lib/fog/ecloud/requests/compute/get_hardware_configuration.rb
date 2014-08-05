module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_hardware_configuration
      end

      class Mock
        def get_hardware_configuration(uri)
          server_id = uri.match(/(\d+)/)[1]

          server = self.data[:servers][server_id.to_i]
          server_hardware_configuration = server[:HardwareConfiguration]

          new_hardware_configuration = {
            :href           => server_hardware_configuration[:href],
            :type           => server_hardware_configuration[:type],
            :ProcessorCount => server_hardware_configuration[:ProcessorCount],
            :Memory         => server_hardware_configuration[:Memory],
            :Disks          => server_hardware_configuration[:Disks],
            :Nics           => server_hardware_configuration[:Nics],
          }

          response(:body => {:HardwareConfiguration => new_hardware_configuration})
        end
      end
    end
  end
end
