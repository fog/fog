require 'fog/core/collection'
require 'fog/ibm/models/compute/key'

module Fog
  module Compute
    class IBM

      class Keys < Fog::Collection

        model Fog::Compute::IBM::Key

        def all
          load(connection.get_keys.body['keys'])
        end

        def get(key_id)
          begin
            new(connection.get_key(key_id).body)
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end

      end
    end
  end
end
