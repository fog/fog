require 'fog/core/model'
require 'fog/rackspace/models/storage/files'
require 'fog/rackspace/models/storage/metadata'

module Fog
  module Storage
    class Rackspace

      class Directory < Fog::Model

        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used', :type => :integer
        attribute :count, :aliases => 'X-Container-Object-Count', :type => :integer
        attribute :cdn_cname
        
        attr_writer :public, :public_url

        def metadata=(hash)
          if hash.is_a? Fog::Storage::Rackspace::Metadata
            @metadata = hash
          else
            @metadata = Fog::Storage::Rackspace::Metadata.new(hash)
          end
          @metadata
        end
        
        def metadata
          unless @metadata
             response = service.head_container(key)
             @metadata = Fog::Storage::Rackspace::Metadata.from_headers(response.headers)
          end
          @metadata
        end

        def destroy
          requires :key
          service.delete_container(key)
          service.cdn.publish_container(self, false) if cdn_enabled?
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
          if @public.nil?
            @public ||= (key && public_url) ? true : false
          end
          @public
        end
        
        def reload
          @public = nil
          @urls = nil
          @files = nil
          super
        end
        
        def public_url          
          return nil if urls.empty?
          return urls[:ssl_uri] if service.ssl?          
          cdn_cname || urls[:uri]
        end
        
        def ios_url
          urls[:ios_uri]
        end
        
        def streaming_url
          urls[:streaming_uri]
        end

        def save
          requires :key

          create_container
          raise Fog::Storage::Rackspace::Error.new("Directory can not be set as :public without a CDN provided") if public? && !cdn_enabled?
          @urls = service.cdn.publish_container(self, public?)
          true
        end
        
        private
        
        def cdn_enabled?
          service.cdn && service.cdn.enabled?
        end
        
        def urls
          requires :key          
          return {} unless cdn_enabled?
          @urls ||= service.cdn.urls(self)
        end
           
        def create_container
          headers = @metadata.nil? ? {} : metadata.to_headers          
          service.put_container(key, headers)        
        end
      end
    end
  end
end
