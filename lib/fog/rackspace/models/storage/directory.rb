require 'fog/core/model'
require 'fog/rackspace/models/storage/files'

module Fog
  module Storage
    class Rackspace

      class Directory < Fog::Model

        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'
        attribute :cdn_cname
        
        attr_writer :public

        def destroy
          requires :key
          service.delete_container(key)
          service.cdn.publish_container(self, false) if service.cdn
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::Rackspace::Files.new(
              :directory    => self,
              :service   => service
            )
          end
        end

        def public?
          @public ||= !public_url.nil?
        end

        def public_url          
          requires :key
          public_url ||= service.cdn.public_url(self) if service.cdn
        end

        def save
          requires :key
          create_container(key)

          raise Fog::Storage::Rackspace::Error.new("Directory can not be set as :public without a CDN provided") if public? && !service.cdn
          public_url = service.cdn.publish_container(self, public?)
        end

      private      
      def create_container(key)
        service.put_container(key)        
      end

    end
  end
end
