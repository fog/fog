module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves a thumbnail image of a VM console.
        #
        # The content type of the response can be any of `image/png`,
        # `image/gif`.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~String> - the thumbnail image.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Thumbnail.html
        # @since vCloud API version 0.9
        def get_thumbnail(id)
          request(
            :expects    => 200,
            :headers    => {'Accept' => "image/*;version=#{@api_version}"},
            :idempotent => true,
            :method     => 'GET',
            :path       => "vApp/#{id}/screen"
          )
        end
      end
    end
  end
end
