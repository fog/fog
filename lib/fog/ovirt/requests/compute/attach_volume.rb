module Fog
  module Compute
    class Ovirt
      class Real
        def attach_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for attach-volume" unless options.key? :id

          client.attach_volume(id, options[:id])
        end
      end

      class Mock
        def attach_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for attach-volume" unless options.key? :id
          true
        end
      end
    end
  end
end
