require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vm_customization'

module Fog
  module Compute
    class VcloudDirector
      class VmCustomizations < Collection
        model Fog::Compute::VcloudDirector::VmCustomization

        attribute :vm
      end
    end
  end
end
