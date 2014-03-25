module Fog
  module Compute
    class VcloudDirector
      class Real
        # Detach a disk from a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [String] disk_id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-DetachDisk.html
        # @since vCloud API version 5.1
        def post_detach_disk(id, disk_id)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            DiskAttachOrDetachParams(attrs) {
              Disk(:href => "#{end_point}disk/#{disk_id}")
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.diskAttachOrDetachParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/disk/action/detach"
          )
        end
      end
    end
  end
end
