module Fog
  module Compute
    class Joyent
      class Real
        def update_machine_metadata(machine_id, metadata)
          request(
            :method => "POST",
            :path => "/my/machines/#{machine_id}/metadata",
            :body => metadata
          )
        end
      end
    end
  end
end
