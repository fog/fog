module Fog
  module Compute
    class Ovirt
      class Real
        def detach_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for detach-volume" unless options.key? :id

          client.detach_volume(id, options[:id])
        end
      end

      class Mock
        def detach_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for detach-volume" unless options.key? :id
          true
        end
      end
    end
  end
end
