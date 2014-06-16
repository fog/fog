require 'fog/compute/models/server'

module Fog
  module Compute
    class OpenNebula
      class Server < Fog::Compute::Server
        identity :id
        attribute :template_str
        attribute :name
        attribute :uuid
        attribute :state
        attribute :status
        attribute :ip
        attribute :mac
        attribute :vcpu
        attribute :cpu
        attribute :memory
        attribute :user
        attribute :gid
        attribute :group
        attribute :onevm_object
        attribute :flavor

        def save
          merge_attributes(service.vm_allocate(attributes))
        end

        # only for integration in foreman
        # needed by formbuilder
        # should be handled by foreman and not by fog
        def vminterfaces
          []
        end

        # only for integration in foreman
        # needed by formbuilder
        # should be handled by foreman and not from by fog
        def vminterfaces_attributes=(attributes)
          true
        end

        def vm_ip_address
          ip
        end

        def private_ip_address
          ip
        end

        def public_ip_address
          ip
        end

        def vm_mac_address
          mac
        end

        def start
          if status == 4
            service.vm_resume(id)
          end
          true
        end	

        def stop
          Fog::Logger.warning("stop VM: ID:#{id}")
          service.vm_stop(id)
        end

        def destroy
          service.vm_destroy(id)
        end

        def ready?
          (status == 3) 
        end

        # only for integration in foreman
        # needed by formbuilder
        # should be handled by foreman and not by fog
        def template_id
          ""
        end

        def console_output
          requires :id
          service.get_vnc_console(id, "vnc", onevm_object)
        end
      end
    end
  end
end
