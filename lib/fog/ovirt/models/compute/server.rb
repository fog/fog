require 'fog/compute/models/server'

module Fog
  module Compute
    class Ovirt

      class Server < Fog::Compute::Server

        # This will be the instance uuid which is globally unique across
        # a oVirt deployment.
        identity :id

        attribute :name
        attribute :description
        attribute :profile
        attribute :display
        attribute :storage,       :aliases => 'disk_size'
        attribute :creation_time
        attribute :os
        attribute :ip
        attribute :status
        attribute :cores,         :aliases => 'cpus'
        attribute :memory
        attribute :host
        attribute :cluster
        attribute :template
        attribute :raw

        def ready?
          !(status =~ /down/i)
        end

        def stopped?
          !!(status =~ /down/i)
        end

        def mac
          raw.interfaces.first.mac if raw.interfaces
        end

        def start(options = {})
          connection.client.vm_action(id, :start)
          reload
        end

        def stop(options = {})
          connection.client.vm_action(id, :stop)
          reload
        end

        def reboot(options = {})
          connection.client.vm_action(id, :reboot)
          reload
        end

        def destroy(options = {})
          stop unless stopped?
          wait_for { stopped? }
          connection.client.destroy_vm(id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          self.id = connection.client.create_vm(attributes).id
          reload
        end

        def to_s
          name
        end

      end

    end
  end
end
