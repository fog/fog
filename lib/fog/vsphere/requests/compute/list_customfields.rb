module Fog
  module Compute
    class Vsphere
      class Real
        def list_customfields()
          @connection.serviceContent.customFieldsManager.field.map do |customfield|
            {
              :key   => customfield.key.to_i,
              :name  => customfield.name,
              :type  => customfield.type
            }
          end
        end
      end
      class Mock
        def list_vm_customfields()
        end
      end
    end
  end
end
