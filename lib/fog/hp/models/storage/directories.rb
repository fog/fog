require 'fog/core/collection'
require 'fog/hp/models/storage/directory'

module Fog
  module Storage
    class HP

      class Directories < Fog::Collection

        model Fog::Storage::HP::Directory

        def all
          data = connection.get_containers.body
          load(data)
        end

        def get(key, options = {})
          read_header = nil
          write_header = nil
          data = connection.get_container(key, options)
          directory = new(:key => key)
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count'].include?(key)
              directory.merge_attributes(key => value)
            end
            if key == 'X-Container-Read'
              read_header = value
            elsif key == 'X-Container-Write'
              write_header = value
            end
          end
          # set the acl on the directory based on the headers
          if !(read_header.nil? && write_header.nil?)
            directory.acl = connection.header_to_acl(read_header, write_header)
          end
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)
          data.body.each do |file|
            directory.files << directory.files.new(file)
          end
          directory
        rescue Fog::Storage::HP::NotFound
          nil
        end

      end

    end
  end
end
