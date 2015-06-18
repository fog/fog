require 'fog/core/collection'
require 'fog/openstack/models/compute/key_pair'

module Fog
  module Compute
    class OpenStack
      class KeyPairs < Fog::Collection
        model Fog::Compute::OpenStack::KeyPair

        def all(options = {})
          items = Array.new
          service.list_key_pairs(options).body['keypairs'].each do |kp|
            items = items + kp.values
          end
          load(items)
        end

        alias_method :summary, :all

        def get(key_pair_name)
          if key_pair_name
            self.all.select {|kp| kp.name == key_pair_name}.first
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
