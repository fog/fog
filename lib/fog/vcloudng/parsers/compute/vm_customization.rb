module Fog
  module Parsers
    module Compute
      module Vcloudng

        class VmCustomization < VcloudngParser

          def reset
            @response = { }
          end

          def start_element(name, attributes)
            super
            case name
            when 'GuestCustomizationSection'
              customizations = extract_attributes(attributes)
              @response.merge!(customizations.reject {|key,value| !['href', 'type'].include?(key)})
              @response['id'] = @response['href'].split('/').last
            end
          end

          def end_element(name)
            case name
            when 'Enabled', 
              @response['enabled'] = (value == "true")
            when 'ChangeSid'
              @response['change_sid'] = (value == "true")
            when 'JoinDomainEnabled'
              @response['join_domain_enabled'] = (value == "true")
            when 'UseOrgSettings'
              @response['use_org_settings'] = (value == "true")
            when 'AdminPasswordEnabled'
              @response['admin_password_enabled'] = (value == "true")
            when 'AdminPasswordAuto'
              @response['admin_password_auto'] = (value == "true")
            when 'ResetPasswordRequired'
              @response['reset_password_required'] = (value == "true")
            when 'VirtualMachineId'
              @response['virtual_machine_id'] = value
            when 'ComputerName'
              @response['computer_name'] = value
            when 'CustomizationScript'
              @response['customization_script'] = value
              @response['has_customization_script'] = !value.empty?
            end
            
          end
          
        end

      end
    end
  end
end
