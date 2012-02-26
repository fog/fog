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

        def initialize(attributes={})
          attributes[:availability_zones] ||= attributes['AvailabilityZones'] || %w(us-east-1a us-east-1b us-east-1c us-east-1d)
          unless attributes['ListenerDescriptions']
            new_listener = Fog::AWS::ELB::Listener.new
            attributes['ListenerDescriptions'] = [{
              'Listener' => new_listener.to_params,
              'PolicyNames' => new_listener.policy_names
            }]
          end
          attributes['Policies'] ||= {'AppCookieStickinessPolicies' => [], 'LBCookieStickinessPolicies' => []}
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

        def listeners
          Fog::AWS::ELB::Listeners.new({
            :data => attributes['ListenerDescriptions'],
            :connection => connection,
            :load_balancer => self
          })
        end

        def policies
          Fog::AWS::ELB::Policies.new({
            :data => attributes['Policies'],
            :connection => connection,
            :load_balancer => self
          })
        end

        def set_listener_policy(port, policy_name)
          requires :id
          policy_name = [policy_name].flatten
          connection.set_load_balancer_policies_of_listener(id, port, policy_name)
          reload
        end

        def set_listener_ssl_certificate(port, ssl_certificate_id)
          requires :id
          connection.set_load_balancer_listener_ssl_certificate(id, port, ssl_certificate_id)
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

          connection.create_load_balancer(availability_zones, id, listeners.map{|l| l.to_params})

          # reload instead of merge attributes b/c some attrs (like HealthCheck)
          # may be set, but only the DNS name is returned in the create_load_balance
          # API call
          reload
        end

        def reload
          super
          @instance_health = nil
          self
        end

        def destroy
          requires :id
          connection.delete_load_balancer(id)
        end

      end
    end
  end
end
