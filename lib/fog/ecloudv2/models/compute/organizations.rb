module Fog
  module Compute
    class Ecloudv2
      class Organizations < Collection
        undef_method :create

        def all
          puts connection.methods.inspect
          puts organization_uri.inspect
          data = connection.get_organizations(organization_uri).body
          load(data)
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
