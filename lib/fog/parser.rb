require 'rubygems'
require 'base64'
require 'nokogiri'
require 'time'

module Fog
  module Parsers
    class Base < Nokogiri::XML::SAX::Document

      attr_reader :response

      def initialize
        reset
      end

      def reset
        @response = {}
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
