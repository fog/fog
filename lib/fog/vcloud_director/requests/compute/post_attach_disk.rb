module Fog
  module Compute
    class VcloudDirector
      class Real
        # Attach a disk to a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [String] disk_id Object identifier of the disk.
        # @param [Hash] options
        # @option options [Integer] :BusNumber Bus number on which to place the
        #   disk controller. If empty or missing, the system assigns a bus
        #   number and a unit number on that bus.
        # @option options [Integer] :BusNumber Unit number (slot) on the bus
        #   specified by :BusNumber. Ignored if :BusNumber is empty or missing.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-AttachDisk.html
        # @since vCloud API version 5.1
        def post_attach_disk(id, disk_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            DiskAttachOrDetachParams(attrs) {
              Disk(:href => "#{end_point}disk/#{disk_id}")
              if options.key?(:BusNumber)
                BusNumber options[:BusNumber]
              end
              if options.key?(:UnitNumber)
                BusNumber options[:UnitNumber]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.diskAttachOrDetachParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/disk/action/attach"
          )
        end
      end
    end
  end
end
