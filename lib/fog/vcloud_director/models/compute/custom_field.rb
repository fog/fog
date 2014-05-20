require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class CustomField < Model

        identity  :id
        attribute :value
        attribute :type
        attribute :password
        attribute :user_configurable

        def set(key, value, opts={})
          service.put_vapp_custom_field(vapp.id, key, value, opts={})
        end

        def destroy
          response = service.delete_vapp_custom_field(vapp.id, key)
          service.process_task(response.body)
        end
      end
    end
  end
end
