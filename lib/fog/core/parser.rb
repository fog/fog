require 'nokogiri'

module Fog
  module Parsers
    class Base < Nokogiri::XML::SAX::Document

      attr_reader :response

      def initialize
        reset
      end

      def attr_value(name, attrs)
        (entry = attrs.detect {|a, v| a == name }) && entry.last
      end

      def reset
        @response = {}
      end

      def characters(string)
        @value ||= ''
        @value << string
      end

      # ###############################################################################
      # This is a workaround. Original implementation from Nokogiri is overwritten with
      # one that does not join namespace prefix with local name.
      def start_element_namespace name, attrs = [], prefix = nil, uri = nil, ns = []
        start_element name, attrs
      end

      def end_element_namespace name, prefix = nil, uri = nil
        end_element name
      end

      # ###############################################################################

      def start_element(name, attrs = [])
        @value = nil
      end

      def value
        @value && @value.dup
      end

    end
  end
end

module Fog
  class ToHashDocument < Nokogiri::XML::SAX::Document

    def initialize
      @stack = []
    end

    def characters(string)
      @value ||= ''
      @value << string.strip
    end

    def end_element(name)
      last = @stack.pop
      if last.empty? && @value.empty?
        @stack.last[name.to_sym] = ''
      elsif last == {:i_nil=>"true"}
        @stack.last[name.to_sym] = nil
      elsif !@value.empty?
        @stack.last[name.to_sym] = @value
      end
      @value = ''
    end

    def body
      @stack.first
    end

    def response
      body
    end

    def start_element(name, attributes = [])
      @value = ''
      parsed_attributes = {}
      until attributes.empty?
        if attributes.first.is_a?(Array)
          key, value = attributes.shift
        else
          key, value = attributes.shift, attributes.shift
        end
        parsed_attributes[key.gsub(':','_').to_sym] = value
      end
      if @stack.last.is_a?(Array)
        @stack.last << {name.to_sym => parsed_attributes}
      else
        data = if @stack.empty?
          @stack.push(parsed_attributes)
          parsed_attributes
        elsif @stack.last[name.to_sym]
          unless @stack.last[name.to_sym].is_a?(Array)
            @stack.last[name.to_sym] = [@stack.last[name.to_sym]]
          end
          @stack.last[name.to_sym] << parsed_attributes
          @stack.last[name.to_sym].last
        else
          @stack.last[name.to_sym] = {}
          @stack.last[name.to_sym].merge!(parsed_attributes)
          @stack.last[name.to_sym]
        end
        @stack.push(data)
      end
    end

  end
end
