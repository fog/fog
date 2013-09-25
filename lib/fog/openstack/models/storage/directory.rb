require 'fog/core/model'
require 'fog/openstack/models/storage/files'

module Fog
  module Storage
    class OpenStack

      class Directory < Fog::Model

        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'

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

        def public=(new_public)
          @public = new_public
        end

        def public_url
          raise NotImplementedError
        end

        def save
          requires :key
          service.put_container(key)
          true
        end

      end

    end
  end
end
