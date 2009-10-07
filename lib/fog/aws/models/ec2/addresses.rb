module Fog
  module AWS
    class EC2

      def addresses
        Fog::AWS::EC2::Addresses.new(:connection => self)
      end

      class Addresses < Fog::Collection

        attribute :public_ip
        attribute :instance_id

        def initialize(attributes)
          @public_ip ||= []
          super
        end

        def all(public_ip = [])
          data = connection.describe_addresses(public_ip).body
          addresses = Fog::AWS::EC2::Addresses.new({
            :connection => connection,
            :public_ip  => public_ip
          }.merge!(attributes))
          data['addressesSet'].each do |address|
            addresses << Fog::AWS::EC2::Address.new({
              :addresses  => self,
              :connection => connection
            }.merge!(address))
          end
          if instance_id
            addresses = addresses.select {|address| address.instance_id == instance_id}
          end
          addresses
        end

        def create
          address = new
          address.save
          address
        end

        def get(public_ip)
          all(public_ip).first
        rescue Fog::Errors::BadRequest
          nil
        end

        def new
          Fog::AWS::EC2::Address.new(
            :addresses  => self,
            :connection => connection
          )
        end

        def reload
          all(public_ip)
        end

      end

    end
  end
end
