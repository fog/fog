require 'fog/core/collection'
require 'fog/exoscale/models/compute/image'

module Fog
  module Compute
    class Exoscale
      class Images < Fog::Collection
        model Fog::Compute::Exoscale::Image

        def all(filters={})
          options = get_filter_options(filters)

          data = service.list_templates(options)["listtemplatesresponse"]["template"] || []
          load(data)
        end

        def get(template_id, filters={})
          filter_option = get_filter_options(filters)
          options = filter_option.merge('id' => template_id)

          if template = service.list_templates(options)["listtemplatesresponse"]["template"].first
            new(template)
          end
        rescue Fog::Compute::Exoscale::BadRequest
          nil
        end

        private

        def get_filter_options(filters)
          default_filter = {
              'templatefilter' => 'executable'
          }
          default_filter.merge(filters)
        end
      end
    end
  end
end
