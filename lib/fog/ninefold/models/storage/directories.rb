require 'fog/core/collection'
require 'fog/ninefold/models/storage/directory'

module Fog
  module Storage
    class Ninefold

      class Directories < Fog::Collection

        attribute :directory

        model Fog::Storage::Ninefold::Directory

        def all
          directory ? ns = directory.key : ns = ''
          ns = ns + '/' unless ns =~ /\/$/
          data = connection.get_namespace(ns).body[:DirectoryList]
          data = {:DirectoryEntry => []} if data.kind_of? String
          data[:DirectoryEntry] = [data[:DirectoryEntry]] if data[:DirectoryEntry].kind_of? Hash
          dirs = data[:DirectoryEntry].select {|de| de[:FileType] == 'directory'}
          dirs.each do |d|
            d[:Filename] = ns + d[:Filename] if directory
            d[:Filename] += '/' unless d[:Filename] =~ /\/$/
          end
          load(dirs)
        end

        def get(key, options = {})
          return nil if key == '' # Root dir shouldn't be retrieved like this.
          key =~ /\/$/ ? ns = key : ns = key + '/'
          res = connection.get_namespace ns
          emc_meta = res.headers['x-emc-meta']
          obj_id = emc_meta.scan(/objectid=(\w+),/).flatten[0]
          new(:objectid => obj_id, :key => ns)
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
