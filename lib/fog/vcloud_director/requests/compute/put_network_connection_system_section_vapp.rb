module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_network, :put_network_connection_system_section_vapp

        require 'fog/vcloud_director/generators/compute/vm_network'

        # Update the network connection section of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Hash] network
        # @option network [String] :info
        # @option network [Integer] :primary_network_connection_index Virtual
        #   slot number associated with the NIC that should be considered this
        #   virtual machine's primary network connection. Defaults to slot 0.
        # @option network [Boolean] :needs_customization True if this NIC needs
        #   customization.
        # @option network [String] :network Name of the network to which this
        #   NIC is connected.
        # @option network [Integer] :network_connection_index Virtual slot
        #   number associated with this NIC.  First slot number is 0.
        # @option network [String] :ip_address IP address assigned to this NIC.
        # @option network [Boolean] :is_connected<~Boolean> If the virtual
        #   machine is undeployed, this value specifies whether the NIC should
        #   be connected upon deployment. If the virtual machine is deployed,
        #   this value reports the current status of this NIC's connection, and
        #   can be updated to change that connection status.
        # @option network [String] :mac_address MAC address associated with the
        #   NIC.
        # @option network [String] :ip_address_allocation_mode IP address
        #   allocation mode for this connection. One of:
        #   * POOL (A static IP address is allocated automatically from a pool
        #     of addresses.)
        #   * DHCP (The IP address is obtained from a DHCP service.)
        #   * MANUAL (The IP address is assigned manually in the :ip_address
        #     element.)
        #   * NONE (No IP addressing mode specified.)
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-NetworkConnectionSystemSection-vApp.html
        # @since vCloud API version 0.9
        def put_network_connection_system_section_vapp(id, network={})
          data = Fog::Generators::Compute::VcloudDirector::VmNetwork.new(network)

          request(
            :body    => data.generate_xml,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.networkConnectionSection+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/networkConnectionSection/"
          )
        end
      end
    end
  end
end
