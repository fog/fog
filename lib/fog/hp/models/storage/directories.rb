require 'fog/core/collection'
require 'fog/hp/models/storage/directory'

module Fog
  module Storage
    class HP
      class Directories < Fog::Collection
        model Fog::Storage::HP::Directory

        def all
          data = service.get_containers.body
          load(data)
        end

        def head(key, options = {})
          data = service.head_container(key)
          directory = create_directory(key, data)
          # set the cdn state for the directory
          directory.cdn_enabled?

          directory
        rescue Fog::Storage::HP::NotFound
          nil
        end

        def get(key, options = {})
          data = service.get_container(key, options)
          directory = create_directory(key, data)
          # set the files for the directory
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)
          data.body.each do |file|
            directory.files << directory.files.new(file)
          end
          # set the cdn state for the directory
          directory.cdn_enabled?

          directory
        rescue Fog::Storage::HP::NotFound
          nil
        end

        private

        def create_directory(key, data)
          read_header = nil
          write_header = nil
          directory = new(:key => key)
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count', 'X-Container-Sync-To', 'X-Container-Sync-Key', 'X-Container-Meta-Web-Index', 'X-Container-Meta-Web-Listings', 'X-Container-Meta-Web-Listings-Css', 'X-Container-Meta-Web-Error'].include?(key)
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
            read_acl, write_acl = service.header_to_perm_acl(read_header, write_header)
            # do not want to expose the read_acl and write_acl as writable attributes
            directory.instance_variable_set(:@read_acl, read_acl)
            directory.instance_variable_set(:@write_acl, write_acl)
          end
          directory
        end
      end
    end
  end
end
