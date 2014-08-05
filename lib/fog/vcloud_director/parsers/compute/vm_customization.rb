module Fog
  module Parsers
    module Compute
      module VcloudDirector
        class VmCustomization < VcloudDirectorParser
          def reset
            @response = { }
          end

          def start_element(name, attributes)
            super
            case name
            when 'GuestCustomizationSection'
              customizations = extract_attributes(attributes)
              @response[:href] = customizations[:href]
              @response[:type] = customizations[:type]
              # href looks like this:
              #  "https://example.com/api/vApp/vm-2bbbf556-55dc-4974-82e6-aa6e814f0b64/guestCustomizationSection/"
              @response[:id] = @response[:href].split('/')[-2]
            end
          end

          def end_element(name)
            case name
            when 'Enabled'
              @response[:enabled] = (value == "true")
            when 'ChangeSid'
              @response[:change_sid] = (value == "true")
            when 'JoinDomainEnabled'
              @response[:join_domain_enabled] = (value == "true")
            when 'UseOrgSettings'
              @response[:use_org_settings] = (value == "true")
            when 'AdminPassword'
              @response[:admin_password] = value
            when 'AdminPasswordEnabled'
              @response[:admin_password_enabled] = (value == "true")
            when 'AdminPasswordAuto'
              @response[:admin_password_auto] = (value == "true")
            when 'ResetPasswordRequired'
              @response[:reset_password_required] = (value == "true")
            when 'VirtualMachineId'
              @response[:virtual_machine_id] = value
            when 'ComputerName'
              @response[:computer_name] = value
            when 'CustomizationScript'
              @response[:has_customization_script] = !value.empty?
              @response[:customization_script] = CGI::unescapeHTML(value) if @response[:has_customization_script]
            end
          end
        end
      end
    end
  end
end
