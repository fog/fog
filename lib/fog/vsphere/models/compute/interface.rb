module Fog
  module Compute
    class Vsphere
      class Interface < Fog::Model
        SAVE_MUTEX = Mutex.new

        identity :mac
        alias_method :id, :mac

        attribute :network
        attribute :name
        attribute :status
        attribute :summary
        attribute :type
        attribute :key
        attribute :virtualswitch
        attribute :server_id

        def initialize(attributes = {})
          # Assign server first to prevent race condition with persisted?
          self.server_id = attributes.delete(:server_id)

          if attributes.key? :type then
            if attributes[:type].is_a? String then
              attributes[:type] = Fog::Vsphere.class_from_string(attributes[:type], "RbVmomi::VIM")
            end
          else
            attributes[:type] = Fog::Vsphere.class_from_string("VirtualE1000", "RbVmomi::VIM")
          end

          super defaults.merge(attributes)
        end

        def to_s
          name
        end

        def server
          requires :server_id
          service.servers.get(server_id)
        end

        def destroy
          requires :server_id, :key, :type

          service.destroy_vm_interface(server_id, :key => key, :type => type)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :server_id, :type, :network

          # Our approach of finding the newly created interface is rough.  We assume that the :key value always increments
          # and thus the highest :key value must correspond to the created interface.  Since this has an inherent race
          # condition we need to gate the saves.
          SAVE_MUTEX.synchronize do
            data = service.add_vm_interface(server_id, attributes)

            if data['task_state'] == 'success'
              # We have to query vSphere to get the interface attributes since the task handle doesn't include that info.
              created = server.interfaces.all.sort_by(&:key).last

              self.mac = created.mac
              self.name = created.name
              self.status = created.status
              self.summary = created.summary
              self.key = created.key
              self.virtualswitch = created.virtualswitch

              true
            else
              false
            end
          end
        end

        private

        def defaults
          default_type=Fog.credentials[:default_nic_type] || RbVmomi::VIM::VirtualE1000
          {
            :name=>"Network adapter",
            :network=>"VM Network",
            :summary=>"VM Network",
            :type=> Fog::Vsphere.class_from_string(default_type, "RbVmomi::VIM"),
          }
        end
      end
    end
  end
end
