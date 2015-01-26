module Fog
  module Compute
    class VcloudDirector
      class Real
        # Enable a vApp template for download.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-EnableVAppTemplateDownload.html
        # @since vCloud API version 0.9
        def post_enable_vapp_template_download(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vAppTemplate/#{id}/action/enableDownload"
          )
        end
      end
    end
  end
end
