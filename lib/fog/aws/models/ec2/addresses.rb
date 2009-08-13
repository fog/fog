module Fog
  module AWS
    class EC2

      def addresses
        Fog::AWS::EC2::Addresses.new(:connection => self)
      end

      class Addresses < Fog::Collection

        def all
          data = connection.get_addresses.body
          addresses = []
          body['addressesSet'].each do |address|
            addresses << Fog::AWS::EC2::Address.new({
              :connection => connection
            }.merge!(address))
          end
          addresses
        end

        def create
          address = new
          address.save
          address
        end

        def new
          Fog::AWS::S3::Address.new(:connection => connection)
        end

      end

    end
  end
end
