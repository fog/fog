module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the value of the specified key from media object metadata.
        #
        # @param [String] id Object identifier of the media object.
        # @param [String] key Key of the metadata.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MediaMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def get_media_metadata_item_metadata(id, key)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "media/#{id}/metadata/#{URI.escape(key)})"
          )
        end
      end
    end
  end
end
