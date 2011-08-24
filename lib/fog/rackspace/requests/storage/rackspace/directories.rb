require 'fog/core/collection'
require 'fog/rackspace/models/storage/directory'

module Fog
  module Storage
    class Rackspace

      class Directories < Fog::Collection

        model Fog::Storage::Rackspace::Directory

        def all
          data = connection.get_containers.body
          load(data)
        end

        # Supply the :cdn_cname option to use the Rackspace CDN CNAME functionality on the public_url.
        #
        # > fog.directories.get('video', :cdn_cname => 'http://cdn.lunenburg.org').files.first.public_url
        # => 'http://cdn.lunenburg.org/hayley-dancing.mov'
        def get(key, options = {})
          data = connection.get_container(key, options)
          directory = new(:key => key, :cdn_cname => options[:cdn_cname])
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count'].include?(key)
              directory.merge_attributes(key => value)
            end
          end
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)
          data.body.each do |file|
            directory.files << directory.files.new(file)
          end
          directory
        rescue Fog::Storage::Rackspace::NotFound
          nil
        end

      end

    end
  end
end
