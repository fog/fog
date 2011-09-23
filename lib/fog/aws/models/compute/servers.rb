require 'fog/core/collection'
require 'fog/aws/models/compute/server'

module Fog
  module Compute
    class AWS

      class Servers < Fog::Collection

        attribute :filters

        model Fog::Compute::AWS::Server

        # Creates a new server
        #
        # AWS.servers.new
        #
        # ==== Returns
        #
        # Returns the details of the new server
        #
        #>> AWS.servers.new
        #  <Fog::AWS::Compute::Server
        #    id=nil,
        #    ami_launch_index=nil,
        #    availability_zone=nil,
        #    block_device_mapping=nil,
        #    client_token=nil,
        #    dns_name=nil,
        #    groups=["default"],
        #    flavor_id="m1.small",
        #    image_id=nil,
        #    ip_address=nil,
        #    kernel_id=nil,
        #    key_name=nil,
        #    created_at=nil,
        #    monitoring=nil,
        #    product_codes=nil,
        #    private_dns_name=nil,
        #    private_ip_address=nil,
        #    ramdisk_id=nil,
        #    reason=nil,
        #    root_device_name=nil,
        #    root_device_type=nil,
        #    state=nil,
        #    state_reason=nil,
        #    subnet_id=nil,
        #    tags=nil,
        #    user_data=nil
        #  >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = self.filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('instance-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'instance-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_instances(filters).body
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

          unless new_attributes[:key_name]
            # first or create fog_#{credential} keypair
            name = Fog.respond_to?(:credential) && Fog.credential || :default
            unless server.key_pair = connection.key_pairs.get("fog_#{name}")
              server.key_pair = connection.key_pairs.create(
                :name => "fog_#{name}",
                :public_key => server.public_key
              )
            end
          end

          # make sure port 22 is open in the first security group
          security_group = connection.security_groups.get(server.groups.first)
          authorized = security_group.ip_permissions.detect do |ip_permission|
            ip_permission['ipRanges'].first && ip_permission['ipRanges'].first['cidrIp'] == '0.0.0.0/0' &&
            ip_permission['fromPort'] == 22 &&
            ip_permission['ipProtocol'] == 'tcp' &&
            ip_permission['toPort'] == 22
          end
          unless authorized
            security_group.authorize_port_range(22..22)
          end

          server.save
          server.wait_for { ready? }
          server.setup(:key_data => [server.private_key])
          server
        end

        # Used to retreive a server
        #
        # server_id is required to get the associated server information.
        #
        # You can run the following command to get the details:
        # AWS.servers.get("i-5c973972")
        #
        # ==== Returns
        #
        #>> AWS.servers.get("i-5c973972")
        #  <Fog::AWS::Compute::Server
        #    id="i-5c973972",
        #    ami_launch_index=0,
        #    availability_zone="us-east-1b",
        #    block_device_mapping=[],
        #    client_token=nil,
        #    dns_name="ec2-25-2-474-44.compute-1.amazonaws.com",
        #    groups=["default"],
        #    flavor_id="m1.small",
        #    image_id="test",
        #    ip_address="25.2.474.44",
        #    kernel_id="aki-4e1e1da7",
        #    key_name=nil,
        #    created_at=Mon Nov 29 18:09:34 -0500 2010,
        #    monitoring=false,
        #    product_codes=[],
        #    private_dns_name="ip-19-76-384-60.ec2.internal",
        #    private_ip_address="19.76.384.60",
        #    ramdisk_id="ari-0b3fff5c",
        #    reason=nil,
        #    root_device_name=nil,
        #    root_device_type="instance-store",
        #    state="running",
        #    state_reason={},
        #    subnet_id=nil,
        #    tags={},
        #    user_data=nil
        #  >
        #
        
        def get(server_id)
          if server_id
            self.class.new(:connection => connection).all('instance-id' => server_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
