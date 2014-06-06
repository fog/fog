require 'fog/vcloud/models/compute/vapp'

module Fog
  module Vcloud
    class Compute
      class Vapps < Collection
        model Fog::Vcloud::Compute::Vapp

        undef_method :create

        attribute :href

        def all
          load([service.get_vdc(service.default_vdc_href).resource_entities].flatten.select { |re| re[:type] == "application/vnd.vmware.vcloud.vApp+xml" })
        end

        def get(uri)
          service.get_vapp(uri)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
