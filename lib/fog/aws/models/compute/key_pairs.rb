require 'fog/core/collection'
require 'fog/aws/models/compute/key_pair'

module Fog
  module AWS
    class Compute

      class KeyPairs < Fog::Collection

        attribute :key_name

        model Fog::AWS::Compute::KeyPair

        def initialize(attributes)
          @filters ||= {}
          super
        end

        def all(filters = @filters)
          @filters = filters
          data = connection.describe_key_pairs(filters).body
          load(data['keySet'])
        end

        def get(key_name)
          if key_name
            self.class.new(:connection => connection).all('key-name' => key_name).first
          end
        end

      end

    end
  end
end
