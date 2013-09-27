module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/customization'

        # Updates the guest customization section of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vm_id ID of the VM to customize.
        # @param [Hash] customization
        # @option customization [Boolean] :enabled True if guest customization
        #   is enabled.
        # @option customization [Boolean] :change_sid True if customization can
        #   change the Windows SID of this virtual machine.
        # @option customization [String] :virtual_machine_id Virtual machine ID
        #   to apply.
        # @option customization [Boolean] :join_domain_enabled True if this
        #   virtual machine can join a Windows Domain.
        # @option customization [Boolean] :use_org_settings True if
        #   customization should use organization settings
        #   (OrgGuestPersonalizationSettings) when joining a Windows Domain.
        # @option customization [String] :domain_name NOT IMPLEMENTED
        # @option customization [String] :domain_user_name NOT IMPLEMENTED
        # @option customization [String] :domain_user_password NOT IMPLEMENTED
        # @option customization [String] :machine_object_ou NOT IMPLEMENTED
        # @option customization [Boolean] :admin_password_enabled True if guest
        #   customization can modify administrator password settings for this
        #   virtual machine.
        # @option customization [Boolean] :admin_password_auto NOT IMPLEMENTED
        # @option customization [String] :admin_password NOT IMPLEMENTED
        # @option customization [Boolean] :reset_password_required - True if
        #   the administrator password for this virtual machine must be reset
        #   after first use.
        # @option customization [String] :customization_script Script to run on
        #   guest customization. The entire script must appear in this element.
        # @option customization [String] :computer_name Computer name to assign
        #   to this virtual machine.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-GuestCustomizationSection-vApp.html
        #   vCloud API Documentation
        def put_vm_customization(vm_id, customization={})
          data = Fog::Generators::Compute::VcloudDirector::Customization.new(customization)

          request(
            :body    => data.generate_xml,
            :expects => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.guestCustomizationSection+xml' },
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
