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
        attribute :server

        model Fog::AWS::EC2::Address

        def initialize(attributes)
          @public_ip ||= []
          super
        end

        def all(public_ip = @public_ip)
          @public_ip = public_ip
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_addresses(public_ip).body
          addresses = []
          data['addressesSet'].each do |address|
            addresses << new(address.reject {|key, value| value.nil? || value.empty? })
          end
          if server
            addresses = addresses.select {|address| address.instance_id == server.id}
          end
          self.replace(addresses)
        end

        def get(public_ip)
          if public_ip
            all(public_ip).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          if server
            super({ :server => server }.merge!(attributes))
          else
            super(attributes)
          end
        end

      end

    end
  end
end
