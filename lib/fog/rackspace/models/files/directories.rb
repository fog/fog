module Fog
  module Rackspace
    class Files

      def directories
        Fog::Rackspace::Files::Directories.new(:connection => self)
      end

      class Directories < Fog::Collection

        model Fog::Rackspace::Files::Directory

        def all
          data = connection.get_containers.body
          load(data)
        end

        def get(name, options = {})
          data = connection.get_container(name, options).body
          directory = new(:name => name)
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
