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
          # If CDN service is available, try to delete the container if it was CDN-enabled
          if cdn_enabled?
            begin
              connection.cdn.delete_container(key)
            rescue Fog::CDN::HP::NotFound
              # ignore if cdn container not found
            end
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
            begin response = connection.head_container(key)
              # escape the key to cover for special char. in container names
              url = "#{connection.url}/#{Fog::HP.escape(key)}"
            rescue Fog::Storage::HP::NotFound => err
              nil
            end
          end
        end

        def cdn_enable=(new_cdn_enable)
          @cdn_enable ||= false
          if (!connection.cdn.nil? && connection.cdn.enabled?)
            @cdn_enable = new_cdn_enable
          else
            # since cdn service is not activated, container cannot be cdn-enabled
            @cdn_enable = false
          end
        end

        def cdn_enabled?
          if (!connection.cdn.nil? && connection.cdn.enabled?)
            begin response = connection.cdn.head_container(key)
              cdn_header = response.headers.fetch('X-Cdn-Enabled', nil)
              if (!cdn_header.nil? && cdn_header == 'True')
                @cdn_enable = true
              else
                @cdn_enable = false
              end
            rescue Fog::CDN::HP::NotFound => err
              @cdn_enable = false
            end
          else
            @cdn_enable = false
          end
        end

        def cdn_public_url
          requires :key
          @cdn_public_url ||= begin
            # return the CDN public url from the appropriate uri from the header
            begin response = connection.cdn.head_container(key)
              if response.headers['X-Cdn-Enabled'] == 'True'
                if connection.hp_cdn_ssl == true
                  response.headers.fetch('X-Cdn-Ssl-Uri', nil)
                else
                  response.headers.fetch('X-Cdn-Uri', nil)
                end
              end
            rescue Fog::CDN::HP::NotFound => err
              nil
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
          # Added an extra check to see if CDN is enabled for the container
          if (!connection.cdn.nil? && connection.cdn.enabled?)
            # If CDN available, set the container to be CDN-enabled or not based on if it is marked as cdn_enable.
            if @cdn_enable
              # check to make sure that the container exists. If yes, cdn enable it.
              begin response = connection.cdn.head_container(key)
                ### Deleting a container from CDN is much more expensive than flipping the bit to disable it
                connection.cdn.post_container(key, {'X-CDN-Enabled' => 'True'})
              rescue Fog::CDN::HP::NotFound => err
                connection.cdn.put_container(key)
              end
            else
              # check to make sure that the container exists. If yes, cdn disable it.
              begin response = connection.cdn.head_container(key)
                ### Deleting a container from CDN is much more expensive than flipping the bit to disable it
                connection.cdn.post_container(key, {'X-CDN-Enabled' => 'False'})
              rescue Fog::CDN::HP::NotFound => err
                # just continue, as container is not cdn-enabled.
              end
            end
          end
          true
        end

      end

    end
  end
end
