require 'fog/vcloud/models/compute/organization'

module Fog
  module Vcloud
    class Compute
      class Organizations < Collection
        model Fog::Vcloud::Compute::Organization

        undef_method :create

        def all
          raw_orgs = if service.version == '1.0'
            service.login
          else
            service.request(service.basic_request_params("#{service.base_path_url}/org/"))
          end
          data = raw_orgs.body[:Org]
          load(data)
        end

        def get(uri)
          service.get_organization(uri)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
