module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the OVF descriptor of a vApp template.
        #
        # @param [String] id Object identifier of the vAppTemplate.
        # @return [Excon::Response]
        #   * body<~String> - the OVF descriptor.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppTemplateOvfDescriptor.html
        # @since vCloud API version 0.9
        def get_vapp_template_ovf_descriptor(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :path       => "vAppTemplate/#{id}/ovf"
          )
        end
      end
    end
  end
end
