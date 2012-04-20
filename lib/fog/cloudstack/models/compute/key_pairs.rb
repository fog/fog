require 'fog/core/collection'
require 'fog/cloudstack/models/compute/key_pair'

module Fog
  module Compute
    class Cloudstack

      class KeyPairs < Fog::Collection

        attribute :filters
        attribute :key_name

        model Fog::Compute::Cloudstack::KeyPair

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          data = connection.list_ssh_key_pairs(filters).body
          load(data['keyPairs'])
        end

        def get(key_name)
          if key_name
            self.class.new(:connection => connection).all('name' => key_name).first
          end
        end

      end
    end
  end
end
