require 'fog/core/model'

module Fog
  module Storage
    class OpenStack
      class File < Fog::Model
        identity  :key,             :aliases => 'name'

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :content_disposition, :aliases => ['content_disposition', 'Content-Disposition']
        attribute :etag,            :aliases => ['hash', 'Etag']
        attribute :last_modified,   :aliases => ['last_modified', 'Last-Modified'], :type => :time
        attribute :access_control_allow_origin, :aliases => ['Access-Control-Allow-Origin']
        attribute :origin,          :aliases => ['Origin']

        def body
          attributes[:body] ||= if last_modified
            collection.get(identity).body
          else
            ''
          end
        end

        def body=(new_body)
          attributes[:body] = new_body
        end

        def directory
          @directory
        end

        def copy(target_directory_key, target_file_key, options={})
          requires :directory, :key
          options['Content-Type'] ||= content_type if content_type
          options['Access-Control-Allow-Origin'] ||= access_control_allow_origin if access_control_allow_origin
          options['Origin'] ||= origin if origin
          service.copy_object(directory.key, key, target_directory_key, target_file_key, options)
          target_directory = service.directories.new(:key => target_directory_key)
          target_directory.files.get(target_file_key)
        end

        def destroy
          requires :directory, :key
          service.delete_object(directory.key, key)
          true
        end

        def metadata
          @metadata ||= headers_to_metadata
        end

        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        def public=(new_public)
          new_public
        end

        # Get a url for file.
        #
        #     required attributes: key
        #
        # @param expires [String] number of seconds (since 1970-01-01 00:00) before url expires
        # @param options [Hash]
        # @return [String] url
        #
        def url(expires, options = {})
          requires :directory, :key
          self.service.create_temp_url(directory.key, key, expires, "GET", options)
        end

        def public_url
          requires :key
          self.collection.get_url(self.key)
        end

        def save(options = {})
          requires :body, :directory, :key
          options['Content-Type'] = content_type if content_type
          options['Content-Disposition'] = content_disposition if content_disposition
          options['Access-Control-Allow-Origin'] = access_control_allow_origin if access_control_allow_origin
          options['Origin'] = origin if origin
          options.merge!(metadata_to_headers)

          data = service.put_object(directory.key, key, body, options)
          update_attributes_from(data)
          refresh_metadata

          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        private

        def directory=(new_directory)
          @directory = new_directory
        end

        def refresh_metadata
          metadata.reject! {|k, v| v.nil? }
        end

        def headers_to_metadata
          key_map = key_mapping
          Hash[metadata_attributes.map {|k, v| [key_map[k], v] }]
        end

        def key_mapping
          key_map = metadata_attributes
          key_map.each_pair {|k, v| key_map[k] = header_to_key(k)}
        end

        def header_to_key(opt)
          opt.gsub(metadata_prefix, '').split('-').map {|k| k[0, 1].downcase + k[1..-1]}.join('_').to_sym
        end

        def metadata_to_headers
          header_map = header_mapping
          Hash[metadata.map {|k, v| [header_map[k], v] }]
        end

        def header_mapping
          header_map = metadata.dup
          header_map.each_pair {|k, v| header_map[k] = key_to_header(k)}
        end

        def key_to_header(key)
          metadata_prefix + key.to_s.split(/[-_]/).map(&:capitalize).join('-')
        end

        def metadata_attributes
          if last_modified
            headers = service.head_object(directory.key, self.key).headers
            headers.reject! {|k, v| !metadata_attribute?(k)}
          else
            {}
          end
        end

        def metadata_attribute?(key)
          key.to_s =~ /^#{metadata_prefix}/
        end

        def metadata_prefix
          "X-Object-Meta-"
        end

        def update_attributes_from(data)
          merge_attributes(data.headers.reject {|key, value| ['Content-Length', 'Content-Type'].include?(key)})
        end
      end
    end
  end
end
