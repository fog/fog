require 'fog/core/collection'
require 'fog/storage/models/ninefold/directory'

module Fog
  module Storage
    class Ninefold

      class Directories < Fog::Collection

        attribute :directory

        model Fog::Storage::Ninefold::Directory

        def all
          directory ? ns = directory.key : ns = ''
          data = connection.get_namespace(ns).body[:DirectoryList]
          data = {:DirectoryEntry => []} if data.kind_of? String
          data[:DirectoryEntry] = [data[:DirectoryEntry]] if data[:DirectoryEntry].kind_of? Hash
          dirs = data[:DirectoryEntry].select {|de| de[:FileType] == 'directory'}
          dirs.each {|d| d[:Filename] = ns + '/' + d[:Filename] if directory}
          load(data[:DirectoryEntry].select {|de| de[:FileType] == 'directory'})
        end

        def get(key, options = {})
          return nil if key == '' # Root dir shouldn't be retrieved like this.
          res = connection.get_namespace key
          emc_meta = res.headers['x-emc-meta']
          obj_id = emc_meta.scan(/objectid=(\w+),/).flatten[0]
          new(:objectid => obj_id, :key => key)
        rescue Fog::Storage::Ninefold::NotFound
          nil
        end

        def new(attributes ={})
          attributes = {:directory => directory}.merge(attributes) if directory
          super(attributes)
        end

      end

    end
  end
end
