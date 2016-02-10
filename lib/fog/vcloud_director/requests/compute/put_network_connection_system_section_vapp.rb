module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_network, :put_network_connection_system_section_vapp

        # Update the network connection section of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Hash] options Container for the network connections of this
        #   virtual machine.
        # @option options [Integer] :PrimaryNetworkConnectionIndex (0)
        #   Virtual slot number associated with the NIC that should be
        #   considered this virtual machine's primary network connection.
        #   Defaults to slot 0.
        # @option options [Array<Hash>] :NetworkConnection
        #   * :needsCustomization<~Boolean> - True if this NIC needs
        #     customization.
        #   * :network<~String> - Name of the network to which this NIC is
        #     connected.
        #   * :NetworkConnectionIndex<~Integer> - Virtual slot number
        #     associated with this NIC. First slot number is 0.
        #   * :IpAddress<~String> - IP address assigned to this NIC.
        #   * :IsConnected<~Boolean> - If the virtual machine is undeployed,
        #     this value specifies whether the NIC should be connected upon
        #     deployment. If the virtual machine is deployed, this value
        #     reports the current status of this NIC's connection, and can be
        #     updated to change that connection status.
        #   * :MACAddress<~String> - MAC address associated with the NIC.
        #   * :IpAddressAllocationMode<~String> - IP address allocation mode
        #     for this connection. One of:
        #     - POOL (A static IP address is allocated automatically from a
        #       pool of addresses.)
        #     - DHCP (The IP address is obtained from a DHCP service.)
        #     - MANUAL (The IP address is assigned manually in the :IpAddress
        #       element.)
        #     - NONE (No IP addressing mode specified.)
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :Tasks<~Hash>:
        #       * :Task<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-NetworkConnectionSystemSection-vApp.html
        # @since vCloud API version 0.9
        def put_network_connection_system_section_vapp(id, options={})
          options = options.dup

          # Mutate options to new format.
          deprecated = {
            :needs_customization => :needsCustomization,
            :network => :network,
            :network_connection_index => :NetworkConnectionIndex,
            :ip_address => :IpAddress,
            :is_connected => :IsConnected,
            :mac_address => :MACAddress,
            :ip_address_allocation_mode => :IpAddressAllocationMode
          }
          option = options.delete(:primary_network_connection_index)
          options[:PrimaryNetworkConnectionIndex] ||= option unless option.nil?
          unless options.key?(:NetworkConnection)
            deprecated.each do |from, to|
              if options.key?(from)
                options[:NetworkConnection] ||= [{}]
                options[:NetworkConnection].first[to] = options.delete(from)
              end
            end
          end

          options[:NetworkConnection] = [options[:NetworkConnection]] if options[:NetworkConnection].is_a?(Hash)

          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
            }
            NetworkConnectionSection(attrs) {
              self[:ovf].Info 'Specifies the available VM network connections'
              if options.key?(:PrimaryNetworkConnectionIndex)
                PrimaryNetworkConnectionIndex options[:PrimaryNetworkConnectionIndex]
              end
              if network_connection = options[:NetworkConnection]
               network_connection.each do |nic|
                  attrs = {
                    :network => nic[:network]
                  }
                  if nic.key?(:needsCustomization)
                    attrs[:needsCustomization] = nic[:needsCustomization]
                  end
                  NetworkConnection(attrs) {
                    NetworkConnectionIndex nic[:NetworkConnectionIndex]
                    if nic.key?(:IpAddress)
                      IpAddress nic[:IpAddress]
                    end
                    IsConnected nic[:IsConnected]
                    if nic.key?(:MACAddress)
                      MACAddress nic[:MACAddress]
                    end
                    IpAddressAllocationMode nic[:IpAddressAllocationMode]
                  }
                end
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.networkConnectionSection+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/networkConnectionSection/"
          )
        end
      end
      class Mock
        def put_network_connection_system_section_vapp(id, options={})
          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end
          
          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vApp+xml'
          }
          task_id = enqueue_task(
            "Updating Virtual Machine #{data[:vms][id][:name]}(#{id})", 'vappUpdateVm', owner,
            :on_success => lambda do
              data[:vms][id][:nics].first[:network_name] = options[:network]
            end
          )
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
          }.merge(task_body(task_id))

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
