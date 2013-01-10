require 'fog/core/model'

module Fog
  module AWS
    class AutoScaling
      class Group < Fog::Model
        identity  :id,                        :aliases => 'AutoScalingGroupName'
        attribute :arn,                       :aliases => 'AutoScalingGroupARN'
        attribute :availability_zones,        :aliases => 'AvailabilityZones'
        attribute :created_at,                :aliases => 'CreatedTime'
        attribute :default_cooldown,          :aliases => 'DefaultCooldown'
        attribute :desired_capacity,          :aliases => 'DesiredCapacity'
        attribute :enabled_metrics,           :aliases => 'EnabledMetrics'
        attribute :health_check_grace_period, :aliases => 'HealthCheckGracePeriod'
        attribute :health_check_type,         :aliases => 'HealthCheckType'
        attribute :instances,                 :aliases => 'Instances'
        attribute :launch_configuration_name, :aliases => 'LaunchConfigurationName'
        attribute :load_balancer_names,       :aliases => 'LoadBalancerNames'
        attribute :max_size,                  :aliases => 'MaxSize'
        attribute :min_size,                  :aliases => 'MinSize'
        attribute :placement_group,           :aliases => 'PlacementGroup'
        attribute :suspended_processes,       :aliases => 'SuspendedProcesses'
        attribute :tags,                      :aliases => 'Tags'
        attribute :termination_policies,      :aliases => 'TerminationPolicies'
        attribute :vpc_zone_identifier,       :aliases => 'VPCZoneIdentifier'

        def initialize(attributes={})
          attributes['DefaultCooldown'] ||= 300
          attributes['DesiredCapacity'] ||= 0
          attributes['EnabledMetrics'] ||= []
          attributes['HealthCheckGracePeriod'] ||= 0
          attributes['HealthCheckType'] ||= 'EC2'
          attributes['Instances'] ||= []
          attributes['LoadBalancerNames'] ||= []
          attributes['MaxSize'] ||= 0
          attributes['MinSize'] ||= 0
          attributes['SuspendedProcesses'] ||= []
          attributes['Tags'] ||= []
          attributes['TerminationPolicies'] ||= ['Default']
          super
        end

        def activities
          requires :id
          data = []
          next_token = nil
          loop do
            result = service.describe_scaling_activities('AutoScalingGroupName' => id, 'NextToken' => next_token).body['DescribeScalingActivitiesResult']
            data += result['Activities']
            next_token = result['NextToken']
            break if next_token.nil?
          end
          Fog::AWS::AutoScaling::Activities.new({
            :data => data,
            :service => service,
            #:load_balancer => self
          })
        end

        def configuration
          requires :launch_configuration_name
          service.configurations.get(launch_configuration_name)
        end

        def disable_metrics_collection(metrics = {})
          requires :id
          service.disable_metrics_collection(id, 'Metrics' => metrics)
          reload
        end

        def enable_metrics_collection(granularity = '1Minute', metrics = {})
          requires :id
          service.enable_metrics_collection(id, granularity, 'Metrics' => metrics)
          reload
        end

        def instances
          Fog::AWS::AutoScaling::Instances.new(:service => service).load(attributes[:instances])
        end

        def instances_in_service
          attributes[:instances].select {|hash| hash['LifecycleState'] == 'InService'}.map {|hash| hash['InstanceId']}
        end

        def instances_out_service
          attributes[:instances].select {|hash| hash['LifecycleState'] == 'OutOfService'}.map {|hash| hash['InstanceId']}
        end

        def resume_processes(processes = [])
          requires :id
          service.resume_processes(id, 'ScalingProcesses' => processes)
          reload
        end

        def suspend_processes(processes = [])
          requires :id
          service.suspend_processes(id, 'ScalingProcesses' => processes)
          reload
        end

        def ready?
          # Is this useful?
          #instances_in_service.length == desired_capacity
          #instances_in_service.length >= min_size
          true
        end

        def save
          requires :id
          requires :availability_zones
          requires :launch_configuration_name
          requires :max_size
          requires :min_size

          service.create_auto_scaling_group(id, availability_zones, launch_configuration_name, max_size, min_size, options)
          reload
        end

        #def reload
        #  super
        #  self
        #end

        def destroy(options = { :force => false })
          requires :id

          opts = {}
          opts.merge!({'ForceDelete' => true}) if options[:force]

          service.delete_auto_scaling_group(id, opts)
        end

        def update
          requires :id
          service.update_auto_scaling_group(id, options)
          reload
        end

        def options
          ret = Hash[self.class.aliases.map { |key, value| [key, send(value)] }]
          ret.delete_if { |key, value| value.nil? }
          ret
        end
      end
    end
  end
end
