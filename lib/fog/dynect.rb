require 'nokogiri'

require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))
require 'fog/core/parser'

module Fog
  module Dynect
    extend Fog::Provider

    service(:dns, 'dynect/dns', 'DNS')

    class Mock
      def self.job_id
        Fog::Mock.random_numbers(8).to_i
      end

      def self.token
        Fog::Mock.random_hex(48)
      end

      def self.version
        [Fog::Mock.random_numbers(1), Fog::Mock.random_numbers(1), Fog::Mock.random_numbers(1)].join('.')
      end
    end
  end
end
