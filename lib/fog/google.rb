require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Google

    extend Fog::Provider

    service(:storage, 'google/storage', 'Storage')

    class Mock

      def self.etag
        hex(32)
      end

      def self.hex(length)
        max = ('f' * length).to_i(16)
        rand(max).to_s(16)
      end

    end
  end
end
