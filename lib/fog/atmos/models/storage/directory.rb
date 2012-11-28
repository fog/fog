require 'fog/core/model'
require 'fog/storage/models/directory'

module Fog
  module Storage
    class Atmos

      class Directory < Fog::Storage::Directory

        identity :key, :aliases => :Filename
        attribute :objectid, :aliases => :ObjectID

        def files
          @files ||= begin
                       Fog::Storage::Atmos::Files.new(
                                                          :directory    => self,
                                                          :connection   => connection
                                                          )
          end
        end

        def directories
          @directories ||= begin
                       Fog::Storage::Atmos::Directories.new(
                                                               :directory    => self,
                                                               :connection   => connection
                                                               )
          end
        end

        def save
          self.key = attributes[:directory].key + key if attributes[:directory]
          self.key = key + '/' unless key =~ /\/$/
          res = connection.post_namespace key
          reload
        end

        def destroy(opts={})
          super(opts)
          connection.delete_namespace key
        end


      end

    end
  end
end
