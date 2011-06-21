require 'fog/core/model'
require 'fog/storage/models/rackspace/files'

module Fog
  module Storage
    class Rackspace

      class Directory < Fog::Model

        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'
        attribute :cdn_cname

        def destroy
          requires :key
          connection.delete_container(key)
          connection.cdn.post_container(key, 'X-CDN-Enabled' => 'False')
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::Rackspace::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def public=(new_public)
          @public = new_public
        end

        def public_url
          requires :key
          @public_url ||= begin
            begin response = connection.cdn.head_container(key)
              if response.headers['X-CDN-Enabled'] == 'True'
                if connection.rackspace_cdn_ssl == true
                  response.headers['X-CDN-SSL-URI']
                else
                  cdn_cname || response.headers['X-CDN-URI']
                end
              end
            rescue Fog::Service::NotFound
              nil
            end
          end
        end

        def save
          requires :key
          connection.put_container(key)
          if @public
            @public_url = connection.cdn.put_container(key, 'X-CDN-Enabled' => 'True').headers['X-CDN-URI']
          else
            connection.cdn.put_container(key, 'X-CDN-Enabled' => 'False')
            @public_url = nil
          end
          true
        end
        
      end

    end
  end
end
