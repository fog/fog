require 'fog/core/collection'
require 'fog/cloudstack/models/compute/image'

module Fog
  module Compute
    class Cloudstack

      class Images < Fog::Collection

        model Fog::Compute::Cloudstack::Image

        def all(filters={})
          options = {
            'templatefilter' => 'self'
          }.merge(filters)

          data = connection.list_templates(options)["listtemplatesresponse"]["template"] || []
          load(data)
        end

        def get(template_id)
          if template = connection.list_templates('id' => template_id)["listtemplatesresponse"]["template"].first
            new(template)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end

    end
  end
end
