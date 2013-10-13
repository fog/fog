module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete the specified key and its value from disk metadata.
        #
        # @param [String] id Object identifier of the disk.
        # @param [String] key Key of the metadata item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-DiskMetadataItem-metadata.html
        # @since vCloud API version 5.1
        def delete_disk_metadata_item_metadata(id, key)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "disk/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end
    end
  end
end
