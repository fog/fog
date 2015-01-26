module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all RASD items that specify hard disk and hard disk
        # controller properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DisksRasdItemsList.html
        # @since vCloud API version 0.9
        def get_disks_rasd_items_list(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/disks"
          )
        end
      end

      class Mock

        def get_disks_rasd_items_list(id)
          type = 'application/vnd.vmware.vcloud.rasdItemsList+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :type => type,
            :href => make_href("vApp/#{id}/virtualHardwareSection/disks"),
            :Link => {
              :rel=>"edit",
              :type=>"application/vnd.vmware.vcloud.rasdItemsList+xml",
              :href=>make_href("vApp/#{id}/virtualHardwareSection/disks"),
            },
            :Item => [
              get_disks_rasd_items_list_body(id, vm),
              get_media_rasd_item_ide_controller_body(id, vm),
            ].flatten
          }

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => body
          )
        end

        def get_disks_rasd_items_list_body(id, vm)
          [
            {
              :"rasd:Address"=>"0",
              :"rasd:Description"=>"SCSI Controller",
              :"rasd:ElementName"=>"SCSI Controller 0",
              :"rasd:InstanceID"=>"2",
              :"rasd:ResourceSubType"=>"lsilogic",
              :"rasd:ResourceType"=>"6"
            },

            # TODO: Add support for adding disks
            {
              :"rasd:AddressOnParent"=>"0",
              :"rasd:Description"=>"Hard disk",
              :"rasd:ElementName"=>"Hard disk 1",
              :"rasd:HostResource"=>{
                :ns12_capacity=>"51200",
                :ns12_busSubType=>"lsilogic",
                :ns12_busType=>"6"
              },
              :"rasd:InstanceID"=>"2000",
              :"rasd:Parent"=>"2",
              :"rasd:ResourceType"=>"17"
            },

          ]
        end

      end

    end
  end
end
