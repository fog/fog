module Fog
  module AWS
    class EC2

      def key_pairs
        Fog::AWS::EC2::KeyPairs.new(:connection => self)
      end

      class KeyPairs < Fog::Collection

        def all(key_name = [])
          data = connection.describe_key_pairs(key_name).body
          key_pairs = []
          data['keySet'].each do |key|
            key_pairs << Fog::AWS::EC2::KeyPair.new({
              :connection => connection
            }.merge!(key))
          end
          key_pairs
        end

        def create(attributes = {})
          bucket = new(attributes)
          bucket.save
          bucket
        end

        def new(attributes = {})
          Fog::AWS::EC2::KeyPair.new(attributes.merge!(:connection => connection))
        end

      end

    end
  end
end
