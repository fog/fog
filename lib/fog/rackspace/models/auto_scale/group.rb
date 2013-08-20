require 'fog/core/model'

module Fog
  module Rackspace
    class AutoScale
      class Group < Fog::Model
         
        identity :id

        attribute :links

        attribute :group_config

        attribute :launch_config

        attribute :policies

        def initialize(attributes={})
          @service = attributes[:service]
          super
        end

        def create(options)
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

        def group_config
          @group_config ||= begin
            Fog::Rackspace::AutoScale::GroupConfig.new({
              :service => service,
              :group => self
            })
          end
        end

        def launch_config
          @launch_config ||= begin
            Fog::Rackspace::AutoScale::LaunchConfig.new({
              :service => service,
              :group => self
            })
          end
        end

        def policies
          @policies ||= begin
            Fog::Rackspace::Autoscale::Policies.new({
              :service => service,
              :group => self
            })
          end
        end

        def state
          requires :identity
          data = service.get_group_state(identity)
          merge_attributes(data.body['group'])
        end

      end
    end
  end
end