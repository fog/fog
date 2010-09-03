require 'fog/collection'
require 'fog/aws/models/ec2/address'

module Fog
  module AWS
    class EC2

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
          data = connection.describe_addresses(public_ip).body
          load(
            data['addressesSet'].map do |address|
              address.reject {|key, value| value.nil? || value.empty? }
            end
          )
          if server
            self.replace(self.select {|address| address.server_id == server.id})
          end
          self
        end

        def get(public_ip)
          if public_ip
            all(public_ip).first
          end
        rescue Fog::Errors::NotFound
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
