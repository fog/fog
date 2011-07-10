require 'fog/core/model'

module Fog
  module Storage
    class Ninefold

      class Directory < Fog::Model

        identity :key, :aliases => :Filename
        attribute :objectid, :aliases => :ObjectID

        def files
          @files ||= begin
                       Fog::Storage::Ninefold::Files.new(
                                                          :directory    => self,
                                                          :connection   => connection
                                                          )
          end
        end

        def directories
          @directories ||= begin
                       Fog::Storage::Ninefold::Directories.new(
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
          if opts[:recursive]
            files.each {|f| f.destroy }
            directories.each do |d|
              d.files.each {|f| f.destroy }
              d.destroy(opts)
            end
          end
          connection.delete_namespace key
        end


      end

    end
  end
end
