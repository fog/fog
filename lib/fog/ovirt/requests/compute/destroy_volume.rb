module Fog
  module Compute
    class Ovirt
      class Real

        def destroy_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for destroy-volume" unless options.has_key? :id

          client.destroy_volume(id, options[:id])
        end

      end

      class Mock
        def destroy_volume(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "volume id is a required parameter for destroy-volume" unless options.has_key? :id
          true
        end

      end
    end
  end
end
