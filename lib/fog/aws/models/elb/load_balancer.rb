require 'fog/core/model'
module Fog
  module AWS
    class ELB

      class LoadBalancer < Fog::Model

        identity  :id,                    :aliases => 'LoadBalancerName'
        attribute :availability_zones,    :aliases => 'AvailabilityZones'
        attribute :created_at,            :aliases => 'CreatedTime'
        attribute :dns_name,              :aliases => 'DNSName'
        attribute :health_check,          :aliases => 'HealthCheck'
        attribute :instances,             :aliases => 'Instances'
        attribute :source_group,          :aliases => 'SourceSecurityGroup'
        attribute :hosted_zone_name,      :aliases => 'CanonicalHostedZoneName'
        attribute :hosted_zone_name_id,   :aliases => 'CanonicalHostedZoneNameID'
        attribute :subnet_ids,            :aliases => 'Subnets'
        attribute :security_groups,       :aliases => 'SecurityGroups'
        attribute :scheme,                :aliases => 'Scheme'
        attribute :vpc_id,                :aliases => 'VPCId'

        def initialize(attributes={})
          if attributes[:subnet_ids] ||= attributes['Subnets']
            attributes[:availability_zones] ||= attributes['AvailabilityZones']
          else
            attributes[:availability_zones] ||= attributes['AvailabilityZones']  || %w(us-east-1a us-east-1b us-east-1c us-east-1d)
          end
          unless attributes['ListenerDescriptions']
            new_listener = Fog::AWS::ELB::Listener.new
            attributes['ListenerDescriptions'] = [{
              'Listener' => new_listener.to_params,
              'PolicyNames' => new_listener.policy_names
            }]
          end
          super
        end

        def register_instances(instances)
          requires :id
          data = service.register_instances_with_load_balancer(instances, id).body['RegisterInstancesWithLoadBalancerResult']
          data['Instances'].map!{|h| h['InstanceId']}
          merge_attributes(data)
        end

        def deregister_instances(instances)
          requires :id
          data = service.deregister_instances_from_load_balancer(instances, id).body['DeregisterInstancesFromLoadBalancerResult']
          data['Instances'].map!{|h| h['InstanceId']}
          merge_attributes(data)
        end

        def enable_availability_zones(zones)
          requires :id
          data = service.enable_availability_zones_for_load_balancer(zones, id).body['EnableAvailabilityZonesForLoadBalancerResult']
          merge_attributes(data)
        end

        def disable_availability_zones(zones)
          requires :id
          data = service.disable_availability_zones_for_load_balancer(zones, id).body['DisableAvailabilityZonesForLoadBalancerResult']
          merge_attributes(data)
        end

        def attach_subnets(subnet_ids)
          requires :id
          data = service.attach_load_balancer_to_subnets(subnet_ids, id).body['AttachLoadBalancerToSubnetsResult']
          merge_attributes(data)
        end

        def detach_subnets(subnet_ids)
          requires :id
          data = service.detach_load_balancer_from_subnets(subnet_ids, id).body['DetachLoadBalancerFromSubnetsResult']
          merge_attributes(data)
        end

        def apply_security_groups(security_groups)
          requires :id
          data = service.apply_security_groups_to_load_balancer(security_groups, id).body['ApplySecurityGroupsToLoadBalancerResult']
          merge_attributes(data)
        end

        def instance_health
          requires :id
          @instance_health ||= service.describe_instance_health(id).body['DescribeInstanceHealthResult']['InstanceStates']
        end

        def instances_in_service
          instance_health.select{|hash| hash['State'] == 'InService'}.map{|hash| hash['InstanceId']}
        end

        def instances_out_of_service
          instance_health.select{|hash| hash['State'] == 'OutOfService'}.map{|hash| hash['InstanceId']}
        end

        def configure_health_check(health_check)
          requires :id
          data = service.configure_health_check(id, health_check).body['ConfigureHealthCheckResult']['HealthCheck']
          merge_attributes(:health_check => data)
        end

        def backend_server_descriptions
          Fog::AWS::ELB::BackendServerDescriptions.new({
            :data => attributes['BackendServerDescriptions'],
            :service => service,
            :load_balancer => self
          })
        end

        def listeners
          Fog::AWS::ELB::Listeners.new({
            :data => attributes['ListenerDescriptions'],
            :service => service,
            :load_balancer => self
          })
        end

        def policies
          Fog::AWS::ELB::Policies.new({
            :data => policy_descriptions,
            :service => service,
            :load_balancer => self
          })
        end

        def policy_descriptions
          requires :id
          @policy_descriptions ||= service.describe_load_balancer_policies(id).body["DescribeLoadBalancerPoliciesResult"]["PolicyDescriptions"]
        end

        def set_listener_policy(port, policy_name)
          requires :id
          policy_name = [policy_name].flatten
          service.set_load_balancer_policies_of_listener(id, port, policy_name)
          reload
        end

        def set_listener_ssl_certificate(port, ssl_certificate_id)
          requires :id
          service.set_load_balancer_listener_ssl_certificate(id, port, ssl_certificate_id)
          reload
        end

        def unset_listener_policy(port)
          set_listener_policy(port, [])
        end

        def ready?
          # ELB requests are synchronous
          true
        end

        def save
          requires :id
          requires :listeners
          # with the VPC release, the ELB can have either availability zones or subnets
          # if both are specified, the availability zones have preference
          #requires :availability_zones
          if (availability_zones || subnet_ids)
            service.create_load_balancer(availability_zones, id, listeners.map{|l| l.to_params}) if availability_zones
            service.create_load_balancer(nil, id, listeners.map{|l| l.to_params}, {:subnet_ids => subnet_ids, :security_groups => security_groups, :scheme => scheme}) if subnet_ids && !availability_zones
          else
            throw Fog::Errors::Error.new("No availability zones or subnet ids specified")
          end

          # reload instead of merge attributes b/c some attrs (like HealthCheck)
          # may be set, but only the DNS name is returned in the create_load_balance
          # API call
          reload
        end

        def reload
          super
          @instance_health = nil
          @policy_descriptions = nil
          self
        end

        def destroy
          requires :id
          service.delete_load_balancer(id)
        end

      end
    end
  end
end
