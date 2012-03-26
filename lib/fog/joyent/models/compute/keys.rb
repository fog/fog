require 'fog/joyent/models/compute/key'

module Fog
  module Compute
    class Joyent
      class Keys < Fog::Collection

        model Fog::Compute::Joyent::Key

        def all
          data = connection.list_keys.body
          load(data)
        end

        def get(keyname)
          data = connection.get_key(keyname).body
          if data
            new(data)
          else
            nil
          end
        end

        def create(params = {})
          raise ArgumentError, "Key name required" unless params.key?(:name)
          raise ArgumentError, "Key body required" unless params.key?(:body)

          self.connection.create_key(params)
        end

      end
    end
  end
end
