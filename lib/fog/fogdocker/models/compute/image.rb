module Fog
  module Compute
    class Fogdocker
      class Image < Fog::Model
        identity :id

        attr_accessor :info

        attribute :repo_tags
        attribute :created
        attribute :size
        attribute :virtual_size

        def name
          repo_tags.empty? ? id : repo_tags.first
        end

        def ready?
          !(status =~ /down/i)
        end

        def destroy(options = {})
          service.image_delete(id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          service.image_create(attributes)
        end

        def to_s
          name
        end
      end
    end
  end
end
