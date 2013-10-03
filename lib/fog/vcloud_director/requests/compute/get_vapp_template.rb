module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a vApp template.
        #
        # @param [String] vapp_template_id Object identifier of the vApp
        #   template.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppTemplate.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_vapp_template(vapp_template_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vAppTemplate/#{vapp_template_id}"
          )
        end
      end
    end
  end
end
