require 'fog/core/model'
module Fog
  module AWS
    class ELB

      class LoadBalancer < Fog::Model

        identity  :id,                    :aliases => 'LoadBalancerName'
        attribute :created_at,            :aliases => 'CreatedTime'
        attribute :health_check,          :aliases => 'HealthCheck'
        attribute :dns_name,              :aliases => 'DNSName'
        attribute :availability_zones,    :aliases => 'AvailabilityZones'
        attribute :instances,             :aliases => 'Instances'
        attribute :listener_descriptions, :aliases => 'ListenerDescriptions'
        attribute :policies,              :aliases => 'Policies'

        attr_accessor :listeners

        def initialize(attributes={})
          attributes[:availability_zones] ||= %w(us-east-1a us-east-1b us-east-1c us-east-1d)
          attributes[:listeners] ||= [{'LoadBalancerPort' => 80, 'InstancePort' => 80, 'Protocol' => 'http'}]
          super
        end

        def register_instances(instances)
          requires :id
          data = connection.register_instances_with_load_balancer(instances, id).body['RegisterInstancesWithLoadBalancerResult']
          data['Instances'].map!{|h| h['InstanceId']}
          merge_attributes(data)
        end

        def deregister_instances(instances)
          requires :id
          data = connection.deregister_instances_from_load_balancer(instances, id).body['DeregisterInstancesFromLoadBalancerResult']
          data['Instances'].map!{|h| h['InstanceId']}
          merge_attributes(data)
        end

        def enable_availability_zones(zones)
          requires :id
          data = connection.enable_availability_zones_for_load_balancer(zones, id).body['EnableAvailabilityZonesForLoadBalancerResult']
          merge_attributes(data)
        end

        def disable_availability_zones(zones)
          requires :id
          data = connection.disable_availability_zones_for_load_balancer(zones, id).body['DisableAvailabilityZonesForLoadBalancerResult']
          merge_attributes(data)
        end

        def instance_health
          requires :id
          @instance_health ||= connection.describe_instance_health(id).body['DescribeInstanceHealthResult']['InstanceStates']
        end

        def instances_in_service
          instance_health.select{|hash| hash['State'] == 'InService'}.map{|hash| hash['InstanceId']}
        end

        def instances_out_of_service
          instance_health.select{|hash| hash['State'] == 'OutOfService'}.map{|hash| hash['InstanceId']}
        end

        def configure_health_check(health_check)
          requires :id
          data = connection.configure_health_check(id, health_check).body['ConfigureHealthCheckResult']['HealthCheck']
          merge_attributes(:health_check => data)
        end

        def create_listener(listener)
          requires :id
          listener = [listener].flatten
          connection.create_load_balancer_listeners(id, listener)
          reload
        end

        def destroy_listener(port)
          requires :id
          port = [port].flatten
          connection.delete_load_balancer_listeners(id, port)
          reload
        end

        def create_app_policy(policy_name, cookie_name)
          requires :id
          connection.create_app_cookie_stickiness_policy(id, policy_name, cookie_name)
          reload
        end

        def create_lb_policy(policy_name, expiration=nil)
          requires :id
          connection.create_lb_cookie_stickiness_policy(id, policy_name, expiration)
          reload
        end

        def destroy_policy(policy_name)
          requires :id
          connection.delete_load_balancer_policy(id, policy_name)
          reload
        end

        def set_listener_policy(port, policy_name)
          requires :id
          policy_name = [policy_name].flatten
          connection.set_load_balancer_policies_of_listener(id, port, policy_name)
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
          requires :availability_zones

          connection.create_load_balancer(availability_zones, id, listeners)

          # reload instead of merge attributes b/c some attrs (like HealthCheck)
          # may be set, but only the DNS name is returned in the create_load_balance
          # API call
          reload
        end

        def reload
          super
          @instance_health, @listeners = nil
        end

        def destroy
          requires :id
          connection.delete_load_balancer(id)
        end

      end
    end
  end
end
