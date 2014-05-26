require 'fog/core/model'
require 'fog/hp/models/storage/files'
require 'fog/hp/models/storage/metadata'

module Fog
  module Storage
    class HP
      class Directory < Fog::Model
        identity  :key,               :aliases => 'name'

        attribute :bytes,             :aliases => 'X-Container-Bytes-Used'
        attribute :count,             :aliases => 'X-Container-Object-Count'
        attribute :sync_to,           :aliases => 'X-Container-Sync-To'
        attribute :sync_key,          :aliases => 'X-Container-Sync-Key'
        attribute :web_index,         :aliases => 'X-Container-Meta-Web-Index'
        attribute :web_listings,      :aliases => 'X-Container-Meta-Web-Listings'
        attribute :web_listings_css,  :aliases => 'X-Container-Meta-Web-Listings-Css'
        attribute :web_error,         :aliases => 'X-Container-Meta-Web-Error'

        def initialize(attributes = {})
            @read_acl  = []
            @write_acl = []
            super
        end

        def read_acl
          @read_acl || []
        end

        def write_acl
          @write_acl || []
        end

        def can_read?(user)
          return false if @read_acl.nil?
          list_users_with_read.include?(user)
        end

        def can_write?(user)
          return false if @write_acl.nil?
          list_users_with_write.include?(user)
        end

        def can_read_write?(user)
          can_read?(user) && can_write?(user)
        end

        def list_users_with_read
          users = []
          users = @read_acl.map  {|acl| acl.split(':')[1]} unless @read_acl.nil?
          return users
        end

        def list_users_with_write
          users = []
          users = @write_acl.map  {|acl| acl.split(':')[1]} unless @write_acl.nil?
          return users
        end

        def grant(perm, users=nil)
          # support passing in a list of users in a comma-separated list or as an Array
          if users.is_a?(String)
            user_list = users.split(',')
          else
            user_list = users
          end
          r_acl, w_acl = service.perm_to_acl(perm, user_list)
          unless r_acl.nil? || r_acl.empty?
            @read_acl = [] if @read_acl.nil?
            @read_acl = @read_acl + r_acl
            @read_acl.uniq!
          end
          unless w_acl.nil? || w_acl.empty?
            @write_acl = [] if @write_acl.nil?
            @write_acl = @write_acl + w_acl
            @write_acl.uniq!
          end
          true
        end

        def revoke(perm, users=nil)
          # support passing in a list of users in a comma-separated list or as an Array
          if users.is_a?(String)
            user_list = users.split(',')
          else
            user_list = users
          end
          r_acl, w_acl = service.perm_to_acl(perm, user_list)
          unless r_acl.nil? || r_acl.empty?
            @read_acl = [] if @read_acl.nil?
            @read_acl = @read_acl - r_acl
            @read_acl.uniq!
          end
          unless w_acl.nil? || w_acl.empty?
            @write_acl = [] if @write_acl.nil?
            @write_acl = @write_acl - w_acl
            @write_acl.uniq!
          end
          true
        end

        def metadata
          @metadata ||= begin
            Fog::Storage::HP::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {'key' => k, 'value' => v} }
          metadata.load(metas)
        end

        def destroy
          requires :key
          service.delete_container(key)
          # If CDN service is available, try to delete the container if it was CDN-enabled
          if cdn_enabled?
            begin
              service.cdn.delete_container(key)
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
              :service   => service
            )
          end
        end

        def public=(new_public)
          if new_public
            self.grant("pr")
          else
            self.revoke("pr")
          end
          @public = new_public
        end

        def public?
          @read_acl = [] if @read_acl.nil?
          if @read_acl.include?(".r:*")
            true
          else
            false
          end
        end

        def public_url
          requires :key
          @public_url ||= begin
            begin response = service.head_container(key)
              # escape the key to cover for special char. in container names
              url = service.public_url(key)
            rescue Fog::Storage::HP::NotFound => err
              nil
            end
          end
        end

        def cdn_enable=(new_cdn_enable)
          @cdn_enable ||= false
          if (!service.cdn.nil? && service.cdn.enabled?)
            @cdn_enable = new_cdn_enable
          else
            # since cdn service is not activated, container cannot be cdn-enabled
            @cdn_enable = false
          end
        end

        def cdn_enabled?
          if (!service.cdn.nil? && service.cdn.enabled?)
            begin response = service.cdn.head_container(key)
              cdn_header = response.headers.fetch('X-Cdn-Enabled', nil)
              if (!cdn_header.nil? && cdn_header == 'True')
                @cdn_enable = true
              else
                @cdn_enable = false
              end
            # If CDN endpoint is unreachable, a SocketError is raised
            rescue Fog::CDN::HP::NotFound, Excon::Errors::SocketError
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
            begin response = service.cdn.head_container(key)
              if response.headers['X-Cdn-Enabled'] == 'True'
                response.headers.fetch('X-Cdn-Uri', nil)
              end
            rescue Fog::CDN::HP::NotFound
              nil
            end
          end
        end

        def cdn_public_ssl_url
          requires :key
          @cdn_public_ssl_url ||= begin
            # return the CDN public ssl url from the appropriate uri from the header
            begin response = service.cdn.head_container(key)
              if response.headers['X-Cdn-Enabled'] == 'True'
                response.headers.fetch('X-Cdn-Ssl-Uri', nil)
              end
            rescue Fog::CDN::HP::NotFound
              nil
            end
          end
        end

        def sync(target_dir, secret)
          requires :key
          # do not sync if dir is same as target dir
          return false if target_dir.key == key
          begin service.head_container(key)
            if !target_dir.nil? && target_dir.is_a?(Fog::Storage::HP::Directory) && target_dir.respond_to?(:public_url) && !target_dir.public_url.nil?
              # set sync metadata on source dir
              self.sync_to = target_dir.public_url
              self.sync_key = secret
              # set sync metadata on target dir
              target_dir.sync_key = secret
              target_dir.save
              true
            else
              false
            end
          rescue Fog::Storage::HP::NotFound
            false
          end
        end

        def save(new_options = {})
          requires :key
          options = {}
          #these are default/previous options
          meta_hash = {}
          metadata.each { |meta| meta_hash.store(meta.key, meta.value) }
          if meta_hash
            options.merge!(meta_hash)
          end
          # write out the acls into the headers before save
          options.merge!(service.perm_acl_to_header(@read_acl, @write_acl))
          options.merge!({'X-Container-Sync-To' => self.sync_to}) unless self.sync_to.nil?
          options.merge!({'X-Container-Sync-Key' => self.sync_key}) unless self.sync_key.nil?
          options.merge!({'X-Container-Meta-Web-Index' => self.web_index}) unless self.web_index.nil?
          options.merge!({'X-Container-Meta-Web-Listings' => self.web_listings})
          options.merge!({'X-Container-Meta-Web-Listings-Css' => self.web_listings_css}) unless self.web_listings_css.nil?
          options.merge!({'X-Container-Meta-Web-Error' => self.web_error}) unless self.web_error.nil?
          # get the metadata and merge them in

          # merge user options at the end
          options.merge!(new_options)

          service.put_container(key, options)
          # Added an extra check to see if CDN is enabled for the container
          if (!service.cdn.nil? && service.cdn.enabled?)
            # If CDN available, set the container to be CDN-enabled or not based on if it is marked as cdn_enable.
            if @cdn_enable
              # check to make sure that the container exists. If yes, cdn enable it.
              begin response = service.cdn.head_container(key)
                if response.headers['X-Cdn-Enabled'] == 'False'
                  service.cdn.post_container(key, {'X-Cdn-Enabled' => 'True'})
                end
              rescue Fog::CDN::HP::NotFound
                service.cdn.put_container(key)
              rescue Excon::Errors::SocketError
                # means that the CDN endpoint is unreachable
              end
            else
              # check to make sure that the container exists. If yes, cdn disable it.
              begin response = service.cdn.head_container(key)
                ### Deleting a container from CDN is much more expensive than flipping the bit to disable it
                if response.headers['X-Cdn-Enabled'] == 'True'
                  service.cdn.post_container(key, {'X-Cdn-Enabled' => 'False'})
                end
              rescue Fog::CDN::HP::NotFound
                # just continue, as container is not cdn-enabled.
              rescue Excon::Errors::SocketError
                # means that the CDN endpoint is unreachable
              end
            end
          end
          true
        end
      end
    end
  end
end
