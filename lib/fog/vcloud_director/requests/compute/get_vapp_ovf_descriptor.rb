module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the OVF descriptor of a vApp directly.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~String> - the OVF descriptor.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppOvfDescriptor.html
        # @since vCloud API version 5.1
        def get_vapp_ovf_descriptor(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :path       => "vApp/#{id}/ovf"
          )
        end
      end
    end
  end
end
