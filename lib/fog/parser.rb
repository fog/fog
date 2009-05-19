require 'rubygems'
require 'nokogiri'

module Fog
  module Parsers
    class Base < Nokogiri::XML::SAX::Document

      attr_reader :result

      def initialize
        reset
      end

      def reset
        @result = {}
      end

      def characters(string)
        @value << string.strip
      end

      def start_element(name, attrs = [])
        @value = ''
      end

    end
  end
end
