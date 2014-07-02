require 'fog/core/collection'
require 'fog/tutum/models/compute/image'

module Fog
  module Compute
  class Tutum
      class Images < Fog::Collection
        model Fog::Compute::Tutum::Image
        attribute :limit
        attribute :offset
        attribute :next
        attribute :previous
        attribute :total_count

        def all(filters = {})
          filters = {
            'limit'   => limit,
            'offset'  => offset
          }.merge!(filters)
          merge_attributes(filters)
          
          load service.image_all(filters)["objects"]
        end

        def get(name)
          new service.image_get(name)
        end

        alias_method :each_file_this_page, :each
        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each_file_this_page {|f| yield f}
            while subset.next
              subset = subset.all(:offset => subset.offset + (subset.limit || 25))
              subset.each_file_this_page {|f| yield f}
            end

            self
          end
        end
      end
    end
  end
end
