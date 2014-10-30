require 'fog/core/model'
require 'fog/openstack/models/storage/files'

module Fog
  module Storage
    class OpenStack
      class Directory < Fog::Model
        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'

        attr_writer :public

        def destroy
          requires :key
          service.delete_container(key)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::OpenStack::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        def public_url
          requires :key
          @public_url ||= begin
            begin response = service.head_container(key)
              # escape the key to cover for special char. in container names
              url = service.public_url(key)
            rescue Fog::Storage::OpenStack::NotFound => err
              nil
            end
          end
        end

        def save
          requires :key
          service.put_container(key, :public => @public)
          true
        end
      end
    end
  end
end
