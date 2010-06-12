require 'fog/collection'
require 'fog/aws/models/ec2/server'

module Fog
  module AWS
    module EC2

      module Collections
        def servers
          Fog::AWS::EC2::Servers.new(:connection => self)
        end
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
          data = connection.describe_instances(server_id).body
          load(
            data['reservationSet'].map do |reservation|
              reservation['instancesSet'].map do |instance|
                instance.merge(:groups => reservation['groupSet'])
              end
            end.flatten
          )
        end

        def get(server_id)
          if server_id
            all(server_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
