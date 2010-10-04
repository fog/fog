require 'fog/core/collection'
require 'fog/aws/models/compute/server'

module Fog
  module AWS
    class Compute

      class Servers < Fog::Collection

        attribute :server_id

        model Fog::AWS::Compute::Server

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

        def bootstrap(new_attributes = {})
          server = connection.servers.new(new_attributes)

          # first or create fog_#{credential} keypair
          unless server.key_pair = connection.key_pairs.get("fog_#{Fog.credential}")
            name = Fog.respond_to?(:credential) && Fog.credential || :default
            server.key_pair = connection.key_pairs.create(
              :name => "fog_#{name}",
              :public_key => server.public_key
            )
          end

          # make sure port 22 is open in the first security group
          security_group = connection.security_groups.get(server.groups.first)
          ip_permission = security_group.ip_permissions.detect do |ip_permission|
            ip_permission['ipRanges'].first && ip_permission['ipRanges'].first['cidrIp'] == '0.0.0.0/0' &&
            ip_permission['fromPort'] == 22 &&
            ip_permission['ipProtocol'] == 'tcp' &&
            ip_permission['toPort'] == 22
          end
          unless ip_permission
            security_group.authorize_port_range(22..22)
          end

          server.save
          server.wait_for { ready? }
          server.setup(:key_data => [server.private_key])
          server
        end

        def get(server_id)
          if server_id
            self.class.new(:connection => connection).all(server_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
