require 'fog/core/collection'
require 'fog/aws/models/compute/spot_request'

module Fog
  module Compute
    class AWS
      class SpotRequests < Fog::Collection
      
        attribute :filters
        
        model Fog::Compute::AWS::SpotRequest

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = self.filters)
          unless filters.is_a?(Hash)
            Fog::Logger.deprecation("all with #{filters.class} param is deprecated, use all('spot-instance-request-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'spot-instance-request-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_spot_instance_requests(filters).body
          load(
            data['spotInstanceRequestSet'].map do |spot_instance_request|
              spot_instance_request['LaunchSpecification.Placement.AvailabilityZone'] = spot_instance_request['launchedAvailabilityZone']
              spot_instance_request['launchSpecification'].each do |name,value|
                spot_instance_request['LaunchSpecification.' + name[0,1].upcase + name[1..-1]] = value
              end
              spot_instance_request.merge(:groups => spot_instance_request['LaunchSpecification.GroupSet'])
              spot_instance_request 
            end.flatten
          )
        end

        def bootstrap(new_attributes = {})
          spot_request = connection.spot_requests.new(new_attributes)

          unless new_attributes[:key_name]
            # first or create fog_#{credential} keypair
            name = Fog.respond_to?(:credential) && Fog.credential || :default
            unless spot_request.key_pair = connection.key_pairs.get("fog_#{name}")
              spot_request.key_pair = connection.key_pairs.create(
                :name => "fog_#{name}",
                :public_key => server.public_key
              )
            end
          end

          # make sure port 22 is open in the first security group
          security_group = connection.security_groups.get(spot_request.groups.first)
          authorized = security_group.ip_permissions.detect do |ip_permission|
            ip_permission['ipRanges'].first && ip_permission['ipRanges'].first['cidrIp'] == '0.0.0.0/0' &&
            ip_permission['fromPort'] == 22 &&
            ip_permission['ipProtocol'] == 'tcp' &&
            ip_permission['toPort'] == 22
          end
          unless authorized
            security_group.authorize_port_range(22..22)
          end

          spot_request.save
          spot_request.wait_for { ready? }
          Fog.wait_for { server = connection.servers.get(spot_request.instance_id) }
          server = connection.servers.get(spot_request.instance_id)
          if spot_request.tags
            for key, value in spot_request.tags
              connection.tags.create(
                :key          => key,
                :resource_id  => spot_request.instance_id,
                :value        => value
              )
            end
          end
          server.wait_for { ready? }
          server.setup(:key_data => [server.private_key])
          server
        end

        def get(spot_request_id)
          if spot_request_id
            self.class.new(:connection => connection).all('spot-instance-request-id' => spot_request_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
