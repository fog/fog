require 'fog/core/model'
require 'fog/rackspace/models/auto_scale/group_config'
require 'fog/rackspace/models/auto_scale/launch_config'
require 'fog/rackspace/models/auto_scale/policies'

module Fog
  module Rackspace
    class AutoScale
      class GroupBuilder
        class << self
          def build(service, attributes)
            service.groups.new :group_config => build_group_config(attributes), :launch_config => build_server_launch_config(attributes)
          end

          def build_group_config(attributes)
            Fog::Rackspace::AutoScale::GroupConfig.new :max_entities => attributes[:max_entities],
              :min_entities => attributes[:min_entities],
              :cooldown => attributes[:cooldown],
              :name => attributes[:name],
              :metadata => attributes[:metadata] || {}
          end

          def build_server_launch_config(attributes)
            return nil unless attributes[:launch_config_type] == :launch_server
            args = {"server" => build_server_template(attributes) }
            args["loadBalancers"] = build_load_balancers(attributes) if attributes[:load_balancers]

            Fog::Rackspace::AutoScale::LaunchConfig.new :type => :launch_server, :args => args
          end

          private

          def build_load_balancers(attributes)
            return nil unless attributes[:load_balancers]

            load_balancers = attributes[:load_balancers].is_a?(Array) ? attributes[:load_balancers] : [attributes[:load_balancers]]
            load_balancers.map do |obj|
              obj.is_a?(Hash) ? obj : load_balancer_to_hash(obj)
            end
          end

          def load_balancer_to_hash(lb)
            raise ArgumentError.new("Expected LoadBalancer") unless lb.respond_to?(:id) && lb.respond_to?(:port)
            {
              "port" =>  lb.port,
              "loadBalancerId" => lb.id
            }
          end

          def build_server_template(attributes)
            image_id = get_id(:image, attributes)
            flavor_id = get_id(:flavor, attributes)

            server_template =   {
              "name" => attributes[:server_name],
              "imageRef" => image_id,
              "flavorRef" => flavor_id,
              "OS-DCF =>diskConfig" => attributes[:disk_config] || "MANUAL",
              "metadata" => attributes[:server_metadata] || {}
            }

            server_template["personality"] = attributes[:personality] if attributes[:personality]
            server_template["user_data"] = [attributes[:user_data]].pack('m') if attributes[:user_data]
            server_template["config_drive"] = 'true' if attributes[:config_drive]
            server_template["networks"] = networks_to_hash(attributes[:networks]) if attributes[:networks]
            server_template
          end

          def model?(obj)
            obj.class.ancestors.include?(Fog::Model)
          end

          def get_id(type, attributes)
            id = attributes["#{type}_id".to_sym]
            type_key = type.to_sym
            id ||= model?(attributes[type_key]) ? attributes[type_key].id : attributes[type_key]
          end

          def networks_to_hash(networks)
            networks.map {|n| {"uuid" => n}}
          end
        end
      end
    end
  end
end
