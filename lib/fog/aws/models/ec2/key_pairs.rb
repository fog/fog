module Fog
  module AWS
    class EC2

      def key_pairs
        Fog::AWS::EC2::KeyPairs.new(:connection => self)
      end

      class KeyPairs < Fog::Collection

        attribute :key_name

        model Fog::AWS::EC2::KeyPair

        def initialize(attributes)
          @key_name ||= []
          super
        end

        def all(key_name = @key_name)
          data = connection.describe_key_pairs(key_name).body
          key_pairs = Fog::AWS::EC2::KeyPairs.new({
            :connection => connection,
            :key_name   => key_name
          }.merge!(attributes))
          data['keySet'].each do |key|
            key_pairs << Fog::AWS::EC2::KeyPair.new({
              :collection => key_pairs,
              :connection => connection
            }.merge!(key))
          end
          key_pairs
        end

        def get(key_name)
          if key_name
            all(key_name).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

      end

    end
  end
end
