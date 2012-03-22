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
        attribute :interfaces
        attribute :raw

        def ready?
          !(status =~ /down/i)
        end

        def locked?
          !!(status =~ /locked/i)
        end

        def stopped?
          !!(status =~ /down/i)
        end

        def mac
          interfaces.first.mac unless interfaces.empty?
        end

        def interfaces
          attributes[:interfaces] ||= id.nil? ? [] : Fog::Compute::Ovirt::Interfaces.new(
              :connection => connection,
              :vm => self
          )
        end

        def add_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          connection.add_interface(id, attrs)
        end

        def update_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          connection.update_interface(id, attrs)
        end

        def destroy_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          connection.destroy_interface(id, attrs)
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

        def ticket(options = {})
          raise "Can not set console ticket, Server is not ready. Server status: #{status}" unless ready?
          connection.vm_ticket(id, options)
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
