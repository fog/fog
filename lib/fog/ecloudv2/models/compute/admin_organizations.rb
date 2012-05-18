require 'fog/ecloudv2/models/compute/admin_organization'

module Fog
  module Compute
    class Ecloudv2
      class AdminOrganizations < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::AdminOrganization

        def all
          data = connection.get_admin_organizations(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_admin_organization(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
