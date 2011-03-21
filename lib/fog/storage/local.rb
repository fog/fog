module Fog
  module Local
    class Storage < Fog::Service

      requires :local_root
      recognizes :provider # remove post deprecation

      model_path 'fog/storage/models/local'
      collection  :directories
      model       :directory
      model       :file
      collection  :files

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          Fog::Mock.not_implemented

          require 'mime/types'
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Local::Storage.new is deprecated, use Fog::Storage.new(:provider => 'Local') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @local_root = ::File.expand_path(options[:local_root])
          @data = self.class.data[@local_root]
        end

        def local_root
          @local_root
        end

        def path_to(partial)
          ::File.join(@local_root, partial)
        end

        def reset_data
          self.class.data.delete(@local_root)
          @data = self.class.data[@local_root]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Local::Storage.new is deprecated, use Fog::Storage.new(:provider => 'Local') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'mime/types'
          @local_root = ::File.expand_path(options[:local_root])
        end

        def local_root
          @local_root
        end

        def path_to(partial)
          ::File.join(@local_root, partial)
        end
      end

    end
  end
end
