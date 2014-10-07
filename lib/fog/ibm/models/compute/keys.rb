require 'fog/core/collection'
require 'fog/ibm/models/compute/key'

module Fog
  module Compute
    class IBM
      class Keys < Fog::Collection
        model Fog::Compute::IBM::Key

        def all
          load(service.list_keys.body['keys'])
        end

        def get(key_id)
          begin
            new(service.get_key(key_id).body)
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end

        def default
          find {|key| key.default? }
        end

        def default=(key_name)
          service.modify_key(key_name, 'default' => true)
        end
      end
    end
  end
end
