module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves the customization section of a vApp template.
        #
        # @param [String] id Object identifier of the vApp template.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppTemplateCustomizationSystemSection.html
        # @since vCloud API version 1.0
        def get_vapp_template_customization_system_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vAppTemplate/#{id}/customizationSection"
          )
        end
      end
    end
  end
end
