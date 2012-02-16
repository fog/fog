require 'fog/core/collection'
require 'fog/openstack/models/compute/key_pair'

module Fog
  module Compute
    class HP

      class KeyPairs < Fog::Collection

        model Fog::Compute::Openstack::KeyPair

        def all
          items = []
          connection.list_key_pairs.body['keypairs'].each do |kp|
            items = items + kp.map { |key, value| value }
          end
          load(items)
        end

        def get(key_pair_name)
          if key_pair_name
            self.all.select {|kp| kp.name == key_pair_name}.first
          end
        rescue Fog::Compute::Openstack::NotFound
          nil
        end

      end
    end
  end
end