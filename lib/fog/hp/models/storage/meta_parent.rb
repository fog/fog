module Fog
  module Storage
    class HP
      module MetaParent
        def parent
          @parent
        end

        def parent=(new_parent)
          @parent = new_parent
        end

        def metas_to_hash(metas)
          hash = {}
          metas.each { |meta| hash.store(meta.key, meta.value) }
          hash
        end
      end
    end
  end
end
