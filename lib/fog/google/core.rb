require 'fog/core'

module Fog
  module Google

    extend Fog::Provider

    service(:compute, 'Compute')
    service(:storage, 'Storage')

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
