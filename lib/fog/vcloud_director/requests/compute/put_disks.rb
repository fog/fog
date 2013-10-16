module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_disks, :put_disks

        require 'fog/vcloud_director/generators/compute/disks'

        # Update all RASD items that specify hard disk and hard disk controller
        # properties of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Array] disks
        #   * disks is the body of #get_vm_disks
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Disks.html
        # @since vCloud API version 0.9
        def put_disks(id, disks=[])
          data = Fog::Generators::Compute::VcloudDirector::Disks.new(disks)

          request(
            :body    => data.generate_xml,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItemsList+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/virtualHardwareSection/disks"
          )
        end
      end
    end
  end
end
