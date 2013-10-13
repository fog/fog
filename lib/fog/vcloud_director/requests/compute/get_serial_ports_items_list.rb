module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all RASD items that specify serial port properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-SerialPortsItemsList.html
        # @since vCloud API version 1.5
        def get_serial_ports_items_list(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/serialPorts"
          )
        end
      end
    end
  end
end
