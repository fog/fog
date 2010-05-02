require 'fog/collection'
require 'fog/local/models/directory'

module Fog
  module Local

    class Real
      def directories
        Fog::Local::Directories.new(:connection => self)
      end
    end

    class Mock
      def directories
        Fog::Local::Directories.new(:connection => self)
      end
    end

    class Directories < Fog::Collection

      model Fog::Local::Directory

      def all
        data = Dir.entries(connection.local_root).select do |entry|
          entry[0...1] != '.' && ::File.directory?(connection.path_to(entry))
        end.map do |entry| 
          {:name => entry}
        end
        load(data)
      end

      def get(name)
        if ::File.directory?(connection.path_to(name))
          new(:name => name)
        else
          nil
        end
      end

    end

  end
end
