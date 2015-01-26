require 'fog/vcloud/models/compute/tag'

module Fog
  module Vcloud
    class Compute
      class Tags < Fog::Vcloud::Collection
        undef_method :create

        model Fog::Vcloud::Compute::Tag

        attribute :href, :aliases => :Href

        def all
          metadata = service.get_metadata(self.href)
          load(metadata.body[:MetadataEntry]) if metadata.body[:MetadataEntry]
        end

        def get(uri)
          service.get_metadata(uri)
        rescue Fog::Errors::NotFound
          nil
        end

        def create(opts)
          service.configure_metadata(opts.merge(href: href))
        end
      end
    end
  end
end
