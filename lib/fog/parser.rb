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
        @value ||= ''
        @value << string.strip
      end

      def start_element(name, attrs = [])
        @value = nil
      end

    end
  end
end
