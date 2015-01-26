module Fog
  module Compute
    class VcloudDirector
      class Real
        # Disable a vApp template for download.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-DisableVAppTemplateDownload.html
        # @since vCloud API version 0.9
        def post_disable_vapp_template_download(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vAppTemplate/#{id}/action/disableDownload"
          )
        end
      end
    end
  end
end
