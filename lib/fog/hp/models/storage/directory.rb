require 'fog/core/model'
require 'fog/hp/models/storage/files'

module Fog
  module Storage
    class HP

      class Directory < Fog::Model

        identity  :key, :aliases => 'name'

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'

        def acl=(new_acl)
          if new_acl.nil?
            new_acl = "private"
          end
          valid_acls = ['private', 'public-read', 'public-write', 'public-read-write']
          unless valid_acls.include?(new_acl)
            raise ArgumentError.new("acl must be one of [#{valid_acls.join(', ')}]")
          end
          @acl = new_acl
        end

        def destroy
          requires :key
          connection.delete_container(key)
          # Added an extra check to see if CDN is nil i.e. when CDN provider is not implemented yet.
          if !connection.cdn.nil?
            connection.cdn.delete_container(key)
          end
          true
        rescue Excon::Errors::NotFound, Fog::Storage::HP::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Storage::HP::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def public=(new_public)
          if new_public
            @acl = 'public-read'
          else
            @acl = 'private'
          end
          @public = new_public
        end

        def public?
          if @acl.nil?
            false
          else
            @acl == 'public-read'
          end
        end

        def public_url
          requires :key
          @public_url ||= begin
            if (!connection.cdn.nil? && connection.cdn.enabled?)
              # return the public url from the appropriate uri from the header
              begin response = connection.cdn.head_container(key)
                if response.headers['X-Cdn-Enabled'] == 'True'
                  if connection.hp_cdn_ssl == true
                    response.headers['X-Cdn-Ssl-Uri']
                  else
                    response.headers['X-Cdn-Uri']
                  end
                end
              rescue Fog::Storage::HP::NotFound => err
                nil
              end
            else
              begin response = connection.head_container(key)
                # escape the key to cover for special char. in container names
                url = "#{connection.url}/#{connection.escape_name(key)}"
              rescue Fog::Storage::HP::NotFound => err
                nil
              end
            end
          end
        end

        def save
          requires :key
          options = {}
          if @acl
            options.merge!(connection.acl_to_header(@acl))
          end
          connection.put_container(key, options)
          # Added an extra check to see if CDN is nil i.e. when CDN provider is not implemented yet.
          if !connection.cdn.nil?
            # If CDN available, set the container to be CDN-enabled or not based on if it is marked as public.
            if @public
              connection.cdn.put_container(key)
            else
              connection.cdn.delete_container(key)
            end
          end
          true
        end

      end

    end
  end
end
