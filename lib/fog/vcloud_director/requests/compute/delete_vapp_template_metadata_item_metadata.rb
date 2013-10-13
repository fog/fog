module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete the specified key and its value from vApp template or VM
        # metadata.
        #
        # @param [String] id Object identifier of the vApp template or VM.
        # @param [String] key Key of the metadata item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-VAppTemplateMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def delete_vapp_template_metadata_item_metadata(id, key)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vAppTemplate/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end
    end
  end
end
