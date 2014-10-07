module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves the guest customization section of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-GuestCustomizationSystemSection-vApp.html
        # @since vCloud API version 1.0
        def get_guest_customization_system_section_vapp(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/guestCustomizationSection"
          )
        end
      end

      class Mock
        def get_guest_customization_system_section_vapp(id)

          type = 'application/vnd.vmware.vcloud.guestCustomizationSection+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vm_guest_customization_section_body(id, vm)
          )
        end

        def get_vm_guest_customization_section_body(id, vm)
          {
            :type => "application/vnd.vmware.vcloud.guestCustomizationSection+xml",
            :href => make_href("vApp/#{id}/guestCustomizationSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "Specifies Guest OS Customization Settings",
            :Enabled => "true",
            :ChangeSid => "false",
            :VirtualMachineId => id.split('-').last, # strip the 'vm-' prefix
            :JoinDomainEnabled => "false",
            :UseOrgSettings => "false",
            :AdminPasswordEnabled => "false",
            :AdminPasswordAuto => "true",
            :ResetPasswordRequired => "false",
            :CustomizationScript => vm[:customization_script] || "",
            :ComputerName => vm[:computer_name] || vm[:name],
            :Link => {
              :rel=>"edit",
              :type=>"application/vnd.vmware.vcloud.guestCustomizationSection+xml",
              :href=>make_href("vApp/#{id}"),
            },
          }
        end

      end
    end
  end
end
