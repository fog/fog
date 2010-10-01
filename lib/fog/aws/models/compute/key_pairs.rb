require 'fog/collection'
require 'fog/aws/models/compute/key_pair'

module Fog
  module AWS
    class Compute

      class KeyPairs < Fog::Collection

        attribute :key_name

        model Fog::AWS::Compute::KeyPair

        def initialize(attributes)
          @key_name ||= []
          super
        end

        def all(key_name = @key_name)
          @key_name = key_name
          data = connection.describe_key_pairs(key_name).body
          load(data['keySet'])
        end

        def get(key_name)
          if key_name
            self.class.new(:connection => connection).all(key_name).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
