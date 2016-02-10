module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_customization, :put_guest_customization_section_vapp

        # Updates the guest customization section of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Hash] options
        # @option options [Boolean] :Enabled True if guest customization is
        #   enabled.
        # @option options [Boolean] :ChangeSid True if customization can change
        #   the Windows SID of this virtual machine.
        # @option options [Boolean] :JoinDomainEnabled True if this virtual
        #   machine can join a Windows Domain.
        # @option options [Boolean] :UseOrgSettings True if customization
        #   should use organization settings (OrgGuestPersonalizationSettings)
        #   when joining a Windows Domain.
        # @option options [String] :DomainName The name of the Windows Domain
        #   to join.
        # @option options [String] :DomainUserName User name to specify when
        #   joining a Windows Domain.
        # @option options [String] :DomainUserPassword Password to use with
        #   :DomainUserName.
        # @option options [String] :MachineObjectOU The name of the Windows
        #   Domain Organizational Unit (OU) in which the computer account for
        #   this virtual machine will be created.
        # @option options [Boolean] :AdminPassword_enabled True if guest
        #   customization can modify administrator password settings for this
        #   virtual machine.
        # @option options [Boolean] :AdminPassword_auto True if the
        #   administrator password for this virtual machine should be
        #   automatically generated.
        # @option options [String] :AdminPassword True if the administrator
        #   password for this virtual machine should be set to this string.
        #   (:AdminPasswordAuto must be false.)
        # @option options [Boolean] :ResetPasswordRequired True if the
        #   administrator password for this virtual machine must be reset after
        #   first use.
        # @option customization [String] :CustomizationScript Script to run on
        #  guest customization. The entire script must appear in this element.
        # @option customization [String] :ComputerName Computer name to assign
        #   to this virtual machine.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :Tasks<~Hash>:
        #       * :Task<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-GuestCustomizationSection-vApp.html
        # @since vCloud API version 1.0
        def put_guest_customization_section_vapp(id, options={})
          options = options.dup

          # Mutate options to new format.
          deprecated = {
            :enabled => :Enabled,
            :change_sid => :ChangeSid,
            :join_domain_enabled => :JoinDomainEnabled,
            :use_org_settings => :UseOrgSettings,
            :admin_password => :AdminPassword,
            :admin_password_enabled => :AdminPasswordEnabled,
            :admin_password_auto => :AdminPasswordAuto,
            :reset_password_required => :ResetPasswordRequired,
            :customization_script => :CustomizationScript,
            :computer_name => :ComputerName
          }
          deprecated.each do |from, to|
            options[to] = options.delete(from) if options.key?(from)
          end

          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
            }
            GuestCustomizationSection(attrs) {
              self['ovf'].Info 'Specifies Guest OS Customization Settings'
              if options.key?(:Enabled)
                Enabled options[:Enabled]
              end
              if options.key?(:ChangeSid)
                ChangeSid options[:ChangeSid]
              end
              if options.key?(:JoinDomainEnabled)
                JoinDomainEnabled options[:JoinDomainEnabled]
              end
              if options.key?(:UseOrgSettings)
                UseOrgSettings options[:UseOrgSettings]
              end
              if options.key?(:DomainName)
                DomainName options[:DomainName]
              end
              if options.key?(:DomainUser)
                DomainUser options[:DomainUser]
              end
              if options.key?(:DomainUserPassword)
                DomainUserPassword options[:DomainUserPassword]
              end
              if options.key?(:MachineObjectOU)
                MachineObjectOU options[:MachineObjectOU]
              end
              if options.key?(:AdminPasswordEnabled)
                AdminPasswordEnabled options[:AdminPasswordEnabled]
              end
              if options.key?(:AdminPasswordAuto)
                AdminPasswordAuto options[:AdminPasswordAuto]
              end
              # Don't add AdminPassword if AdminPasswordAuto is true
              if options.key?(:AdminPassword) and !options[:AdminPasswordAuto]
                AdminPassword options[:AdminPassword]
              end
              if options.key?(:ResetPasswordRequired)
                ResetPasswordRequired options[:ResetPasswordRequired]
              end
              if options.key?(:CustomizationScript)
                CustomizationScript options[:CustomizationScript]
              end
              if options.key?(:ComputerName)
                ComputerName options[:ComputerName]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.guestCustomizationSection+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
