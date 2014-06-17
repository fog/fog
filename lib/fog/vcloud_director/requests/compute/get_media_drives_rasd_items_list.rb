module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all RASD items that specify CD-ROM, DVD, and floppy disk
        # device and controller properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MediaDrivesRasdItemsList.html
        # @since vCloud API version 0.9
        def get_media_drives_rasd_items_list(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/media"
          )
        end
      end

      class Mock

        def get_media_drives_rasd_items_list(id)
          type = 'application/vnd.vmware.vcloud.rasdItemsList+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :type => type,
            :href => make_href("vApp/#{id}/virtualHardwareSection/media"),
            :Item => [
              get_media_rasd_item_ide_controller_body(id, vm),
              get_media_rasd_item_cdrom_body(id, vm),
              get_media_rasd_item_floppy_body(id, vm),
            ]
          }

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => body
          )
        end

        def get_media_rasd_item_ide_controller_body(id, vm)
          {
            :"rasd:Address"=>"0",
            :"rasd:Description"=>"IDE Controller",
            :"rasd:ElementName"=>"IDE Controller 0",
            :"rasd:InstanceID"=>"3",
            :"rasd:ResourceType"=>"5"
          }
        end

        def get_media_rasd_item_cdrom_body(id, vm)
          {
            :"rasd:AddressOnParent"=>"1",
            :"rasd:AutomaticAllocation"=>"true",
            :"rasd:Description"=>"CD/DVD Drive",
            :"rasd:ElementName"=>"CD/DVD Drive 1",
            :"rasd:HostResource"=>"",
            :"rasd:InstanceID"=>"3000",
            :"rasd:Parent"=>"3",
            :"rasd:ResourceType"=>"15"
          }
        end

        def get_media_rasd_item_floppy_body(id, vm)
          {
            :"rasd:AddressOnParent"=>"0",
            :"rasd:AutomaticAllocation"=>"false",
            :"rasd:Description"=>"Floppy Drive",
            :"rasd:ElementName"=>"Floppy Drive 1",
            :"rasd:HostResource"=>"",
            :"rasd:InstanceID"=>"8000",
            :"rasd:ResourceType"=>"14"
          }
        end

      end

    end
  end
end
