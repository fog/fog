module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the network connection section of a VM.
        #
        # @param [String] id The object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkConnectionSystemSection-vApp.html
        # @since vCloud API version 0.9
        def get_network_connection_system_section_vapp(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/networkConnectionSection/"
          )
        end
      end

      class Mock

        def get_network_connection_system_section_vapp(id)
          type = 'application/vnd.vmware.vcloud.networkConnectionSection+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vm_network_connection_section_body(id, vm)
          )

        end

        def get_vm_network_connection_section_body(id, vm)
          # TODO: Needs work - does not handle multiple NIC case yet, or
          #       DHCP/POOL allocations
          {
            :type => "application/vnd.vmware.vcloud.networkConnectionSection+xml",
            :href => make_href("vApp/#{id}/networkConnectionSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "Specifies the available VM network connections",
            :PrimaryNetworkConnectionIndex => "0",
            :NetworkConnection => {
              :network => vm[:nics][0][:network_name],
              :needsCustomization => "false",
              :NetworkConnectionIndex => "0",
              :IpAddress => vm[:nics][0][:ip_address],
              :IsConnected => "true",
              :MACAddress => vm[:nics][0][:mac_address],
              :IpAddressAllocationMode => "MANUAL"
            }
          }
        end

      end

    end
  end
end
