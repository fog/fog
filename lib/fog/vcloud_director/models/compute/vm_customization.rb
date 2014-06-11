require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class VmCustomization < Model
        identity  :id

        attribute :type
        attribute :href
        attribute :enabled
        attribute :change_sid
        attribute :join_domain_enabled
        attribute :use_org_settings
        attribute :admin_password_auto
        attribute :admin_password
        attribute :admin_password_enabled
        attribute :reset_password_required
        attribute :virtual_machine_id
        attribute :computer_name
        attribute :has_customization_script

        # bug: for some reason if the customization_script has /r, is showed
        # here as /n. Looks likes is something in excon
        def script
          attributes[:customization_script]
        end

        def script=(new_script)
          attributes[:customization_script] = new_script
        end

        def save
          response = service.put_guest_customization_section_vapp(id, attributes)
          service.process_task(response.body)
        end
      end
    end
  end
end
