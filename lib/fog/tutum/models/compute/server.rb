require 'fog/compute/models/server'

module Fog
  module Compute
    class Tutum
      # fog server is a docker container
      class Server < Fog::Compute::Server
        identity :uuid

        attribute :application
        attribute :autodestroy
        attribute :autoreplace
        attribute :autorestart
        attribute :container_envvars
        attribute :container_ports
        attribute :container_size
        attribute :deployed_datetime
        attribute :destroyed_datetime
        attribute :entrypoint
        attribute :exit_code
        attribute :exit_code_msg
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
        attribute :started_datetime
        attribute :state
        attribute :stopped_datetime
        attribute :unique_name

        def ready?
          reload if state.nil?
          state == "Running"
        end

        def stopped?
          !ready?
        end

        def start(options = {})
          service.container_action(uuid, :start)
          reload
        end

        def stop(options = {})
          service.container_action(uuid, :stop)
          reload
        end

        def redeploy(options = {})
          service.container_action(uuid, :redeploy, options)
          reload
        end

        def restart(options = {})
          stop options
          while(state != "Stopped")
            sleep 1
            reload
          end
          start options
          reload
        end

        def wait_for_stop
          count = 0
          while state != "Stopped" && count < 10
            sleep 1
            count = count + 1
            reload
          end

        end

        def destroy(options = {})
          stop unless stopped?
          service.container_terminate(uuid)
        end

        def save
          if !persisted?
            self.uuid = service.container_create(attributes)['uuid']
          end
          reload
        end

        def logs
          service.container_logs(uuid)
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
