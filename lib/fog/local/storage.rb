require File.expand_path(File.join(File.dirname(__FILE__), '..', 'storage'))
require 'fog/storage'

module Fog
  module Storage
    class Local < Fog::Service

      requires :local_root

      model_path 'fog/local/models/storage'
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

        def self.reset
          @data = nil
        end

        def initialize(options={})
          Fog::Mock.not_implemented

          require 'mime/types'
          @local_root = ::File.expand_path(options[:local_root])
        end

        def data
          self.class.data[@local_root]
        end

        def local_root
          @local_root
        end

        def path_to(partial)
          ::File.join(@local_root, partial)
        end

        def reset_data
          self.class.data.delete(@local_root)
        end

      end

      class Real

        def initialize(options={})
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
