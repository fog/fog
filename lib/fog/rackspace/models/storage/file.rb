require 'fog/core/model'

module Fog
  module Storage
    class Rackspace

      class File < Fog::Model

        identity  :key,             :aliases => 'name'

        attribute :content_length,  :aliases => ['bytes', 'Content-Length'], :type => :integer
        attribute :content_type,    :aliases => ['content_type', 'Content-Type']
        attribute :etag,            :aliases => ['hash', 'Etag']
        attribute :last_modified,   :aliases => ['last_modified', 'Last-Modified'], :type => :time
        attribute :access_control_allow_origin, :aliases => ['Access-Control-Allow-Origin']
        attribute :origin,          :aliases => ['Origin']
        
        attr_writer :public

        attr_accessor :directory
        attr_writer :public

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

        def metadata=(hash)
          if hash.is_a? Fog::Storage::Rackspace::Metadata
            attributes[:metadata] = hash
          else
            attributes[:metadata] = Fog::Storage::Rackspace::Metadata.new(self, hash)
          end
          attributes[:metadata]
        end
        
        def metadata
          attributes[:metadata] ||= Fog::Storage::Rackspace::Metadata.new(self)
        end
        
        def owner=(new_owner)
          if new_owner
            attributes[:owner] = {
              :display_name => new_owner['DisplayName'],
              :id           => new_owner['ID']
            }
          end
        end

        def public?
          directory.public?
        end
        
        def public_url
          Files::file_url directory.public_url, key
        end
        
        def ios_url
          Files::file_url directory.ios_url, key
        end
        
        def streaming_url
          Files::file_url directory.streaming_url, key
        end      
        
        def purge_from_cdn
          if public?
            service.cdn.purge(self)
          else
            false
          end
        end

        def save(options = {})
          requires :body, :directory, :key
          options['Content-Type'] = content_type if content_type
          options['Access-Control-Allow-Origin'] = access_control_allow_origin if access_control_allow_origin
          options['Origin'] = origin if origin
          options.merge!(metadata.to_headers)

          data = service.put_object(directory.key, key, body, options)
          update_attributes_from(data)
          
          self.content_length = Fog::Storage.get_body_size(body)
          self.content_type ||= Fog::Storage.get_content_type(body)
          true
        end

        private

        def update_attributes_from(data)
          merge_attributes(data.headers.reject {|key, value| ['Content-Length', 'Content-Type'].include?(key)})
        end
      end

    end
  end
end
