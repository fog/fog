module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete the specified key and its value from media object metadata.
        #
        # @param [String] id Object identifier of the media object.
        # @param [String] key Key of the metadata item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-MediaMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def delete_media_metadata_item_metadata(id, key)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "media/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end
    end
  end
end
