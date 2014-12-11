require 'fog/core/collection'
require 'fog/rackspace/models/storage/directory'

module Fog
  module Storage
    class Rackspace
      class Directories < Fog::Collection
        model Fog::Storage::Rackspace::Directory

        # Returns list of directories
        # @return [Fog::Storage::Rackspace::Directories] Retrieves a list directories.
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @note Fog's current implementation only returns 10,000 directories
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/View_List_of_Containers-d1e1100.html
        def all
          data = service.get_containers.body
          load(data)
        end

        # Retrieves directory
        # @param [String] key  of directory
        # @param options [Hash]:
        # @option options [String] cdn_cname CDN CNAME used when calling Directory#public_url
        # @return [Fog::Storage::Rackspace::Directory]
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @example
        #   directory = fog.directories.get('video', :cdn_cname => 'http://cdn.lunenburg.org')
        #   files = directory.files
        #   files.first.public_url
        #
        # @see Directory#public_url
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/View-Container_Info-d1e1285.html
        def get(key, options = {})
          data = service.get_container(key, options)
          directory = new(:key => key, :cdn_cname => options[:cdn_cname])
          for key, value in data.headers
            if ['X-Container-Bytes-Used', 'X-Container-Object-Count'].include?(key)
              directory.merge_attributes(key => value)
            end
          end

          directory.metadata = Metadata.from_headers(directory, data.headers)
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
