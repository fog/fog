module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all RASD items that specify network card properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkCardsItemsList.html
        # @since vCloud API version 0.9
        def get_network_cards_items_list(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/networkCards"
          )
        end
      end

      class Mock
        def get_network_cards_items_list(id)
          type = 'application/vnd.vmware.vcloud.rasdItemsList+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :type => type,
            :href => make_href("vApp/#{id}/virtualHardwareSection/networkCards"),
            :Link => {
              :rel=>"edit",
              :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
              :href=>make_href("vApp/#{id}/virtualHardwareSection/networkCards"),
            },
            :Item => get_network_cards_rasd_items_list_body(id, vm)
          }

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => body
          )

        end

        def get_network_cards_rasd_items_list_body(id, vm)
          [{
            :"rasd:Address" => vm[:nics][0][:mac_address],
            :"rasd:AddressOnParent" => "0",
            :"rasd:AutomaticAllocation" => "true",
            :"rasd:Connection" => vm[:nics][0][:network_name],
            :"rasd:Description" => "E1000 ethernet adapter",
            :"rasd:ElementName" => "Network adapter 0",
            :"rasd:InstanceID" => "1",
            :"rasd:ResourceSubType" => "E1000",
            :"rasd:ResourceType" => "10"
          }]
        end

      end
    end
  end
end
