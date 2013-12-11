require 'fog/core/collection'
require 'fog/openstack/models/image/image'

module Fog
  module Image
    class OpenStack
      class Images < Fog::Collection
        model Fog::Image::OpenStack::Image

        def all
          load(service.list_public_images_detailed.body['images'])
        end

        def details
          load(service.list_public_images_detailed.body['images'])
        end

        def find_by_id(id)
          all.find {|image| image.id == id}
        end
        alias_method :get, :find_by_id

        def public
          images = load(service.list_public_images_detailed.body['images'])
          images.delete_if{|image| image.is_public == false}
        end

        def private
          images = load(service.list_public_images_detailed.body['images'])
          images.delete_if{|image| image.is_public}
        end

        def destroy(id)
          image = self.find_by_id(id)
          image.destroy
        end

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            load(service.list_public_images_detailed($1 ,arguments.first).body['images'])
          else
            super
          end
        end

        def find_by_size_min(size)
          find_attribute(__method__, size)
        end

        def find_by_size_max(size)
          find_attribute(__method__, size)
        end

        def find_attribute(attribute,value)
          attribute = attribute.to_s.gsub("find_by_", "")
          load(service.list_public_images_detailed(attribute , value).body['images'])
        end
      end
    end
  end
end
