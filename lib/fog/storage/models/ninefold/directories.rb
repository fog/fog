require 'fog/core/collection'
require 'fog/storage/models/ninefold/directory'

module Fog
  module Storage
    class Ninefold

      class Directories < Fog::Collection

        model Fog::Storage::Ninefold::Directory

        def all
          data = connection.get_namespace.body[:DirectoryList]
          data = {:DirectoryEntry => []} if data.kind_of? String
          data[:DirectoryEntry] = [data[:DirectoryEntry]] if data[:DirectoryEntry].kind_of? Hash
          load(data[:DirectoryEntry])
        end

        def get(key, options = {})
          return nil if key == '' # Root dir shouldn't be retrieved like this.
          res = connection.get_namespace key
          emc_meta = res.headers['x-emc-meta']
          obj_id = emc_meta.scan(/objectid=(\w+),/).flatten[0]
          new(:id => obj_id, :filename => key, :type => 'directory')
        rescue Fog::Storage::Ninefold::NotFound
          nil
        end

      end

    end
  end
end
