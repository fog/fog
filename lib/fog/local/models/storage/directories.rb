require 'fog/core/collection'
require 'fog/local/models/storage/directory'

module Fog
  module Storage
    class Local
      class Directories < Fog::Collection
        model Fog::Storage::Local::Directory

        def all
          data = if ::File.directory?(service.local_root)
            Dir.entries(service.local_root).select do |entry|
              entry[0...1] != '.' && ::File.directory?(service.path_to(entry))
            end.map do |entry|
              {:key => entry}
            end
          else
            []
          end
          load(data)
        end

        def get(key, options = {})
          if ::File.directory?(service.path_to(key))
            new(:key => key)
          else
            nil
          end
        end
      end
    end
  end
end
