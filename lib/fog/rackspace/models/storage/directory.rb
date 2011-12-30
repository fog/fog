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

          if @connection.cdn && @public
            # if public and CDN connection then update cdn to public
            uri_header = 'X-CDN-URI'
            if connection.rackspace_cdn_ssl == true
              uri_header = 'X-CDN-SSL-URI'
            end
            @public_url = connection.cdn.put_container(key, 'X-CDN-Enabled' => 'True').headers[uri_header]
          elsif @connection.cdn && !@public
            connection.cdn.put_container(key, 'X-CDN-Enabled' => 'False')
            @public_url = nil
          elsif !@connection.cdn && @public
            # if public but no CDN connection then error
            raise(Fog::Storage::Rackspace::Error.new("Directory can not be set as :public without a CDN provided"))
          end
          true
        end

      end

    end
  end
end
