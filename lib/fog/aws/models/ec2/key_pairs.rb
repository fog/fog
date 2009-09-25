module Fog
  module AWS
    class EC2

      def key_pairs
        Fog::AWS::EC2::KeyPairs.new(:connection => self)
      end

      class KeyPairs < Fog::Collection

        attribute :key_name

        def all(key_name = [])
          data = connection.describe_key_pairs(key_name).body
          key_pairs = Fog::AWS::EC2::KeyPairs.new(
            :connection => connection,
            :key_name   => key_name
          )
          data['keySet'].each do |key|
            key_pairs << Fog::AWS::EC2::KeyPair.new({
              :connection => connection,
              :key_pairs  => self
            }.merge!(key))
          end
          key_pairs
        end

        def create(attributes = {})
          bucket = new(attributes)
          bucket.save
          bucket
        end

        def get(key_name)
          all(key_name).first
        rescue Fog::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          Fog::AWS::EC2::KeyPair.new(
            attributes.merge!(
              :connection => connection,
              :key_pairs  => self
            )
          )
        end

        def reload
          all(key_name)
        end

      end

    end
  end
end
