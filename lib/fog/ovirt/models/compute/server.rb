require 'fog/compute/models/server'

module Fog
  module Compute
    class Ovirt
      class Server < Fog::Compute::Server
        # This will be the instance uuid which is globally unique across
        # a oVirt deployment.
        identity :id

        attribute :name
        attribute :comment
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
        attribute :instance_type
        attribute :interfaces
        attribute :volumes
        attribute :raw
        attribute :quota
        attribute :ips
        attribute :ha
        attribute :ha_priority

        def ready?
          !(status =~ /down/i)
        end

        def locked?
          @volumes = nil # force reload volumes
          !!(status =~ /locked/i) || (attributes[:volumes]=nil) || volumes.any?{|v| !!(v.status =~ /locked/i)}
        end

        def stopped?
          !!(status =~ /down/i)
        end

        def mac
          interfaces.first.mac unless interfaces.empty?
        end

        def interfaces
          @interfaces ||= id.nil? ? [] : Fog::Compute::Ovirt::Interfaces.new(
              :service => service,
              :vm => self
          )
        end

        def add_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          service.add_interface(id, attrs)
        end

        def update_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          service.update_interface(id, attrs)
        end

        def destroy_interface attrs
          wait_for { stopped? } if attrs[:blocking]
          service.destroy_interface(id, attrs)
        end

        def volumes
          @volumes ||= id.nil? ? [] : Fog::Compute::Ovirt::Volumes.new(
              :service => service,
              :vm => self
          )
        end

        def add_volume attrs
          wait_for { stopped? } if attrs[:blocking]
          service.add_volume(id, attrs)
        end

        def destroy_volume attrs
          wait_for { stopped? } if attrs[:blocking]
          service.destroy_volume(id, attrs)
        end

        def update_volume attrs
          wait_for { stopped? } if attrs[:blocking]
          service.update_volume(id, attrs)
        end

        def attach_volume(attrs)
          wait_for { stopped? } if attrs[:blocking]
          service.attach_volume(id, attrs)
        end

        def detach_volume(attrs)
          wait_for { stopped? } if attrs[:blocking]
          service.detach_volume(id, attrs)
        end

        def add_to_affinity_group(attrs)
          wait_for { stopped? } if attrs[:blocking]
          service.add_to_affinity_group(id, attrs)
        end
        
        def remove_from_affinity_group(attrs)
          wait_for { stopped? } if attrs[:blocking]
          service.remove_from_affinity_group(id, attrs)
        end

        def start(options = {})
          wait_for { !locked? } if options[:blocking]
          service.vm_action(:id =>id, :action => :start)
          reload
        end

        def start_with_cloudinit(options = {})
          wait_for { !locked? } if options[:blocking]
          user_data = Hash[YAML.load(options[:user_data]).map{|a| [a.first.to_sym, a.last]}]
          service.vm_start_with_cloudinit(:id =>id, :user_data =>user_data)
          reload
        end

        def stop(options = {})
          service.vm_action(:id =>id, :action => :stop)
          reload
        end

        def reboot(options = {})
          stop unless stopped?
          start options.merge(:blocking => true)
        end

        def suspend(options = {})
          service.vm_action(:id =>id, :action => :suspend)
          reload
        end

        def destroy(options = {})
          (stop unless stopped?) rescue nil #ignore failure, destroy the machine anyway.
          wait_for { stopped? }
          service.destroy_vm(:id => id)
        end

        def ticket(options = {})
          raise "Can not set console ticket, Server is not ready. Server status: #{status}" unless ready?
          service.vm_ticket(id, options)
        end

        def save
          if persisted?
            service.update_vm(attributes)
          else
            self.id = service.create_vm(attributes).id
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
