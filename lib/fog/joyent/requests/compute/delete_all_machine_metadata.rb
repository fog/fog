module Fog
  module Compute
    class Joyent
      class Real
        # https://us-west-1.api.joyentcloud.com/docs#DeleteMachineMetadata
        def delete_all_machine_metadata(machine_id)
          request(
            :method => "DELETE",
            :path => "/my/machines/#{machine_id}/metadata",
            :expects => 204
          )
        end
      end
    end
  end
end
