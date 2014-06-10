module Fog
  module Compute
    class Joyent
      class Real
        # https://us-west-1.api.joyentcloud.com/docs#DeleteAllMachineMetadata
        def delete_machine_metadata(machine_id, key)
          request(
            :method => "DELETE",
            :path => "/my/machines/#{machine_id}/metadata/#{key}",
            :expects => [200, 204]
          )
        end
      end
    end
  end
end
