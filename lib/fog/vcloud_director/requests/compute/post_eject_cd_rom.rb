module Fog
  module Compute
    class VcloudDirector
      class Real
        # Eject virtual media.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [String] media_id Object identifier of the media object.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-EjectCdRom.html
        # @since vCloud API version 0.9
        def post_eject_cd_rom(id, media_id)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            MediaInsertOrEjectParams(attrs) {
              Media(:href => "#{end_point}media/#{media_id}")
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.mediaInsertOrEjectParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/media/action/ejectMedia"
          )
        end
      end
    end
  end
end
