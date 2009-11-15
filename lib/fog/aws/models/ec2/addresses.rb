module Fog
  module AWS
    class EC2

      def addresses(attributes = {})
        Fog::AWS::EC2::Addresses.new({
          :connection => self
        }.merge!(attributes))
      end

      class Addresses < Fog::Collection

        attribute :public_ip
        attribute :instance

        model Fog::AWS::EC2::Address

        def initialize(attributes)
          @public_ip ||= []
          super
        end

        def all(public_ip = @public_ip)
          data = connection.describe_addresses(public_ip).body
          addresses = Fog::AWS::EC2::Addresses.new({
            :connection => connection,
            :public_ip  => public_ip
          }.merge!(attributes))
          data['addressesSet'].each do |address|
            addresses << new(address.reject {|key, value| value.nil? || value.empty? })
          end
          if instance
            addresses = addresses.select {|address| address.instance_id == instance.id}
          end
          addresses
        end

        def get(public_ip)
          if public_ip
            all(public_ip).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          super({ :instance => instance }.merge!(attributes))
        end

      end

    end
  end
end
