require 'fog/collection'
require 'fog/rackspace/models/files/directory'

module Fog
  module Rackspace
    class Storage

      class Directories < Fog::Collection

        model Fog::Rackspace::Storage::Directory

        def all
          data = connection.get_containers.body
          load(data)
        end

        def get(key, options = {})
          data = connection.get_container(key, options).body
          directory = new(:key => key)
          directory.files.merge_attributes(options)
          directory.files.instance_variable_set(:@loaded, true)
          data.each do |file|
            directory.files << directory.files.new(file)
          end
          directory
        rescue Fog::Rackspace::Storage::NotFound
          nil
        end

      end

    end
  end
end
