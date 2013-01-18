module Fog
  module Compute
    class Joyent

      class Real
        # https://us-west-1.api.joyentcloud.com/docs#AddMachineTags
        def add_machine_tags(machine_id, tags={})
          raise ArgumentError, "tags must be a Hash of tags" unless tags.is_a?(Hash)

          request(
            :path => "/my/machines/#{machine_id}/tags",
            :method => "POST",
            :body => tags,
            :expects => 200
          )
        end
      end
    end
  end
end
