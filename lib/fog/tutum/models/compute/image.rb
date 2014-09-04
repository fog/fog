module Fog
  module Compute
    class Tutum
      class Image < Fog::Model
        identity :name
        attribute :image_url
        attribute :imagetag_set
        attribute :is_private_image
        attribute :base_image
        attribute :cluster_aware
        attribute :description
        attribute :public_url
        attribute :resource_uri
        attribute :starred
        attribute :docker_registry

        attr_accessor :username, :password
        
        def destroy(options = {})
          service.image_delete(name).body
        end

        def to_s
          name
        end

        def registry_host
          docker_registry["host"]
        end

        def registry_image_url
          docker_registry["image_url"]
        end
        
        def is_tutum_registry
          docker_registry["is_tutum_registry"]
        end

        def registry_name
          docker_registry["name"]
        end

        def registry_resource_url
          docker_registry["resource_url"]
        end

        def registry_uuid
          docker_registry["uuid"]
        end

        def tag(name)
          imagetags.select {|t| t["name"] == name}.first
        end

        def latest
          tag("latest")
        end

        def save(options = {})
          if persisted?
            update(options)
          else
            create(options)
          end
        end

        def create(options = {})
          requires :name, :username, :password
          options = {
            'description' => description
          }
          options = options.reject {|key, value| value.nil?}
          data = service.image_create(name, username, password, options)
          merge_attributes(data.body)
          true
        end

        def update(options = {})
          requires :name
          options = {
            'username'    => username,
            'password'    => password,
            'description' => description
          }
          options = options.reject {|key, value| value.nil?}
          data = service.image_update(name, options)
          merge_attributes(data.body)
          true
        end

        def persisted?
          resource_uri
        end
      end
    end
  end
end
