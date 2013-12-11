module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a list of all VMs attached to a disk.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VmsDisksAttachedTo.html
        # @since vCloud API version 5.1
        def get_vms_disk_attached_to(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "disk/#{id}/attachedVms"
          )
          ensure_list! response.body, :VmReference
          response
        end
      end

      class Mock
        def get_vms_disk_attached_to(id)
          unless data[:disks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "com.vmware.vcloud.entity.disk:%s".' % id
            )
          end

          Fog::Mock.not_implemented
        end
      end
    end
  end
end
