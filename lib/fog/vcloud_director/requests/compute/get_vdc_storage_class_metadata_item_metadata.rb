module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the vDC storage profile.
        #
        # @param [String] id Object identifier of the vDC storage profile.
        # @param [String] key Key of the metadata.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcStorageClassMetadataItem-metadata.html
        def get_vdc_storage_class_metadata_item_metadata(id, key)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vdcStorageProfile/#{id}/metadata/#{URI.escape(key)})"
          )
        end
      end
    end
  end
end
