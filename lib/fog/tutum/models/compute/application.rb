require 'fog/compute/models/server'

module Fog
  module Compute
    class Tutum
      # fog application is a docker cluster
      class Application < Fog::Compute::Server
        identity :uuid

        attribute :autodestroy
        attribute :autoreplace
        attribute :autorestart
        attribute :container_envvars
        attribute :container_ports
        attribute :container_size
        attribute :containers
        attribute :current_num_containers
        attribute :deployed_datetime
        attribute :destroyed_datetime
        attribute :entrypoint
        attribute :image_name
        attribute :image_tag
        attribute :link_variables
        attribute :linked_from_application
        attribute :linked_to_application
        attribute :linked_from_container
        attribute :linked_to_container
        attribute :name
        attribute :public_dns
        attribute :resource_uri
        attribute :roles
        attribute :run_command
        attribute :running_num_containers
        attribute :sequential_deployment
        attribute :started_datetime
        attribute :state
        attribute :stopped_datetime
        attribute :stopped_num_containers
        attribute :target_num_containers
        attribute :unique_name
        attribute :web_public_dns

        def ready?
          reload if state.nil?
          state == "Running"
        end

        def stopped?
          !ready?
        end
   
        def start(options = {})
          service.application_action(uuid, :start)
          reload
        end

        def stop(options = {})
          service.application_action(uuid, :stop)
          reload
        end

        def redeploy(options = {})
          service.application_action(uuid, :redeploy, options)
          reload
        end

        def restart(options = {})
          stop options
          start options
          reload
        end

        def destroy(options = {})
          stop unless stopped?
          service.application_terminate(uuid)
        end

        def save
          if persisted?
            service.application_update(uuid, attributes)
          else
            self.uuid = service.application_create(image_name, attributes)['uuid']
          end
          reload
        end
        
        def application_containers
          container_keys = containers.map {|c| c.split("/")[-2]}
          container_keys.map {|k| containers.get(k) }
        end

        def envvar(name)
          ev = envvars.select {|e| e["key"] == key }
          ev["value"] if ev
        end

        def to_s
          name
        end
      end
    end
  end
end
