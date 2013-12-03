require 'fog/core/model'

module Fog
  module Storage
    class Atmos

      class Directory < Fog::Model

        identity :key, :aliases => :Filename
        attribute :objectid, :aliases => :ObjectID

        def files
          @files ||= begin
                       Fog::Storage::Atmos::Files.new(
                         :directory => self,
                         :service   => service
                       )
                     end
        end

        def directories
          @directories ||= begin
                             Fog::Storage::Atmos::Directories.new(
                               :directory => self,
                               :service   => service
                             )
                           end
        end

        def save
          self.key = attributes[:directory].key + key if attributes[:directory]
          self.key = key + '/' unless key =~ /\/$/
          res = service.post_namespace key
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
          service.delete_namespace key
        end


      end

    end
  end
end
