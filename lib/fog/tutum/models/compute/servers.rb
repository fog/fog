require 'fog/core/collection'
require 'fog/tutum/models/compute/server'

module Fog
  module Compute
    class Tutum
      class Servers < Fog::Collection
        model Fog::Compute::Tutum::Server

        attribute :limit
        attribute :offset
        attribute :next
        attribute :previous
        attribute :total_count

        def all(filters = {})
          filters['limit'] ||= (limit || 25)
          filters['offset'] ||= (offset || 0)

          merge_attributes(filters)
          load service.container_all(filters)["objects"]
        end

        def get(uuid)
          new service.container_get(uuid)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes[:image], new_attributes)
          server
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
