module Fog
  module Compute
    class RackspaceV2
      module MetaParent
        # Parent of metadata
        # @return [#parent] parent of metadata
        def parent
          @parent
        end

        # Sets parent of metadata
        # @param [#parent] new_parent of metadata
        def parent=(new_parent)
          @parent = new_parent
        end

        # Collection type for parent
        # @return [String] collection type
        # @raise [RuntimeError] raises excpetion if collection type for parent is unknown
        def collection_name
          if parent.class == Fog::Compute::RackspaceV2::Image
            return "images"
          elsif parent.class == Fog::Compute::RackspaceV2::Server
            return "servers"
          else
            raise "Metadata is not supported for this model type."
          end
        end

        # Converts metadata to hash
        # @return [Hash] hash containing key value pairs for metadata
        def metas_to_hash(metas)
          hash = {}
          metas.each { |meta| hash[meta.key] = meta.value }
          hash
        end
      end
    end
  end
end
