require 'fog/core/collection'
require 'fog/hp/models/storage/shared_directory'

module Fog
  module Storage
    class HP
      class SharedDirectories < Fog::Collection
        model Fog::Storage::HP::SharedDirectory

        def all
          nil
        end

        def head(url)
          data = service.head_shared_container(url)
          shared_directory = new(:url => url)
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count'].include?(key)
              shared_directory.merge_attributes(key => value)
            end
          end

          shared_directory
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def get(url)
          data = service.get_shared_container(url)
          shared_directory = new(:url => url)
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count'].include?(key)
              shared_directory.merge_attributes(key => value)
            end
          end
          # set the files for the directory
          shared_directory.files.instance_variable_set(:@loaded, true)
          data.body.each do |file|
            shared_directory.files << shared_directory.files.new(file)
          end

          shared_directory
        # throws exception Fog::HP::Errors::Forbidden if insufficient access
        rescue Fog::Storage::HP::NotFound
          nil
        end
      end
    end
  end
end
