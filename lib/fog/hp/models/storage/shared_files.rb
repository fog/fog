require 'fog/core/collection'
require 'fog/hp/models/storage/shared_file'

module Fog
  module Storage
    class HP
      class SharedFiles < Fog::Collection
        attribute :shared_directory

        model Fog::Storage::HP::SharedFile

        def all
          requires :shared_directory
          parent = shared_directory.collection.get(shared_directory.url)
          if parent
            load(parent.files.map {|file| file.attributes})
          else
            nil
          end
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def get(key, &block)
          requires :shared_directory
          shared_object_url = "#{shared_directory.url}/#{key}"
          data = service.get_shared_object(shared_object_url, &block)
          file_data = data.headers.merge({
            :body => data.body,
            :key  => key
          })
          new(file_data)
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def head(key)
          requires :shared_directory
          shared_object_url = "#{shared_directory.url}/#{key}"
          data = service.head_shared_object(shared_object_url)
          file_data = data.headers.merge({
            :body => '',
            :key => key
          })
          new(file_data)
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def new(attributes = {})
          requires :shared_directory
          super({ :shared_directory => shared_directory }.merge!(attributes))
        end
      end
    end
  end
end
