require 'fog/core/model'
require 'fog/rackspace/models/auto_scale/group_config'
require 'fog/rackspace/models/auto_scale/launch_config'
require 'fog/rackspace/models/auto_scale/policies'

module Fog
  module Rackspace
    class AutoScale
      class Group < Fog::Model
         
        identity :id

        attribute :links

        def initialize(attributes={})
          @service = attributes[:service]
          super
        end

        def group_config
          data = service.get_group_config(identity)
          attributes[:group_config] = begin 
            Fog::Rackspace::AutoScale::GroupConfig.new({
              :service => @service,
              :group   => self
            }).merge_attributes(data.body['groupConfiguration']) 
          end
          attributes[:group_config]
        end

        def group_config=(object={})
          if object.is_a?(Hash)
            attributes[:group_config] = begin 
              Fog::Rackspace::AutoScale::GroupConfig.new({
                :service => @service,
                :group   => self
              }).merge_attributes(object) 
            end
          else
            attributes[:group_config] = object
          end
        end

        def launch_config
          data = service.get_launch_config(identity)
          attributes[:launch_config] = begin 
            Fog::Rackspace::AutoScale::LaunchConfig.new({
              :service => @service,
              :group   => self
            }).merge_attributes(data.body['launchConfiguration']) 
          end
          attributes[:launch_config]
        end

        def launch_config=(object={})
          if object.is_a?(Hash)
            attributes[:launch_config] = begin 
              Fog::Rackspace::AutoScale::LaunchConfig.new({
                :service => @service,
                :group   => self
              }).merge_attributes(object) 
            end
          else
            attributes[:launch_config] = object
          end
        end

        def policies
          @policies ||= begin
            Fog::Rackspace::AutoScale::Policies.new({
              :service => service,
              :group => self
            })
          end
        end

        def save
          requires :launch_config, :group_config, :policies

          data = service.create_group(launch_config, group_config, policies)
          merge_attributes(data.body['group'])
          true
        end

        def destroy
          requires :identity
          service.delete_server(identity)
          true
        end

        def state
          requires :identity
          data = service.get_group_state(identity)
          data.body['group']
        end

        def pause
          requires :identity
          data = service.pause_group_state(identity)
          true
        end

        def resume
          requires :identity
          data = service.resume_group_state(identity)
          true
        end

      end
    end
  end
end