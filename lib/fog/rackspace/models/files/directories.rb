require 'fog/collection'
require 'fog/rackspace/models/files/directory'

module Fog
  module Rackspace
    module Files

      class Real
        def directories
          Fog::Rackspace::Files::Directories.new(:connection => self)
        end
      end

      class Mock
        def directories
          Fog::Rackspace::Files::Directories.new(:connection => self)
        end
      end

      class Directories < Fog::Collection

        model Fog::Rackspace::Files::Directory

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
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
