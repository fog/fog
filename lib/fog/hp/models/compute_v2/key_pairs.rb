require 'fog/core/collection'
require 'fog/hp/models/compute_v2/key_pair'

module Fog
  module Compute
    class HPV2
      class KeyPairs < Fog::Collection
        model Fog::Compute::HPV2::KeyPair

        def all
          items = []
          service.list_key_pairs.body['keypairs'].each do |kp|
            items = items + kp.map { |_, value| value }
          end
          load(items)
        end

        def get(key_pair_name)
          if key_pair_name
            self.all.select {|kp| kp.name == key_pair_name}.first
          end
        rescue Fog::Compute::HPV2::NotFound
          nil
        end
      end
    end
  end
end
