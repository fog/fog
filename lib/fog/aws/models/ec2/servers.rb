module Fog
  module AWS
    class EC2

      def servers
        Fog::AWS::EC2::Servers.new(:connection => self)
      end

      class Servers < Fog::Collection

        attribute :server_id

        model Fog::AWS::EC2::Server

        def initialize(attributes)
          @server_id ||= []
          super
        end

        def all(server_id = @server_id)
          @server_id = server_id
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_instances(server_id).body
          data['reservationSet'].each do |reservation|
            reservation['instancesSet'].each do |instance|
              self << new(instance)
            end
          end
          self
        end

        def get(server_id)
          if server_id
            all(server_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

      end

    end
  end
end
