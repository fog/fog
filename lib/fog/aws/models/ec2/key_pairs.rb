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
          @key_name = key_name
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_key_pairs(key_name).body
          data['keySet'].each do |key|
            self << new(key)
          end
          self
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
