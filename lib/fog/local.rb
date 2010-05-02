module Fog
  module Local

    def self.new(options={})

      unless @required
        require 'fog/local/models/directories'
        require 'fog/local/models/directory'
        require 'fog/local/models/file'
        require 'fog/local/models/files'
        @required = true
      end

      unless options[:local_root]
        raise ArgumentError.new('local_root is required to access local')
      end
      if Fog.mocking?
        Fog::Local::Mock.new(options)
      else
        Fog::Local::Real.new(options)
      end
    end

    def self.reset_data(keys=Mock.data.keys)
      Mock.reset_data(keys)
    end

    class Mock

      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def self.reset_data(keys=data.keys)
        for key in [*keys]
          data.delete(key)
        end
      end

      def initialize(options={})
        @local_root = ::File.expand_path(options[:local_root])
        @data       = self.class.data[@local_root]
      end

      def local_root
        @local_root
      end

      def path(partial)
        partial
      end
    end

    class Real

      def initialize(options={})
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