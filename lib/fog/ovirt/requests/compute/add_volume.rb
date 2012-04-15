module Fog
  module Compute
    class Ovirt
      class Real

        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          options[:size]=options[:size_gb].to_i*1073741824 if options[:size_gb]
          client.add_volume(id, options)
        end

      end

      class Mock
        def add_volume(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          true
        end

      end
    end
  end
end