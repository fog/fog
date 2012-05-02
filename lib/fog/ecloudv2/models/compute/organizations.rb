require 'fog/ecloudv2/models/compute/organization'

module Fog
  module Compute
    class Ecloudv2
      class Organizations < Fog::Ecloudv2::Collection

        model Fog::Compute::Ecloudv2::Organization

        undef_method :create

        identity :href

        def all
          data = connection.get_organizations(organization_uri).body
          load(data[:Organization])
        end

        def get(uri)
          if data = connection.get_organization(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def organization_uri
          @organization_uri ||= connection.default_organization_uri
        end

        private

        def organization_uri=(new_organization_uri)
          @organization_uri = new_organization_uri
        end
      end
    end
  end
end
