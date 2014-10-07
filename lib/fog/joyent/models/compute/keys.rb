require 'fog/joyent/models/compute/key'

module Fog
  module Compute
    class Joyent
      class Keys < Fog::Collection
        model Fog::Compute::Joyent::Key

        def all
          data = service.list_keys.body
          load(data)
        end

        def get(keyname)
          data = service.get_key(keyname).body
          if data
            new(data)
          else
            nil
          end
        end

        def create(params = {})
          raise ArgumentError, "option [name] required" unless params.key?(:name)
          raise ArgumentError, "option [key] required" unless params.key?(:key)

          service.create_key(params)
        end
      end
    end
  end
end
