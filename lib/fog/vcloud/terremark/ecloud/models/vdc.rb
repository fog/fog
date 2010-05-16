module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class Vdc < Fog::Vcloud::Vdc

          delete_attribute :enabled
          delete_attribute :vm_quota
          delete_attribute :nic_quota
          delete_attribute :network_quota
          delete_attribute :allocation_model

          attribute :deployed_vm_quota
          attribute :instantiated_vm_quota

        end
      end
    end
  end
end
