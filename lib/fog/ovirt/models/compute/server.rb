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
          wait_for { stopped? } if options[:blocking]
          connection.vm_action(:id =>id, :action => :start)
          reload
        end

        def stop(options = {})
          connection.vm_action(:id =>id, :action => :stop)
          reload
        end

        def reboot(options = {})
          stop unless stopped?
          start options.merge(:blocking => true)
        end

        def suspend(options = {})
          connection.vm_action(:id =>id, :action => :suspend)
          reload
        end

        def destroy(options = {})
          (stop unless stopped?) rescue nil #ignore failure, destroy the machine anyway.
          wait_for { stopped? }
          connection.destroy_vm(:id => id)
        end

        def save
          if identity
            connection.update_vm(attributes)
          else
            self.id = connection.create_vm(attributes).id
          end
          reload
        end

        def to_s
          name
        end

      end

    end
  end
end
