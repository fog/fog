require "rexml/document"
require 'erb'
require 'ostruct'

module Fog
  module Compute
    module LibvirtUtil

      # finds a value from xml
      def document path, attribute=nil
        return nil if new?
        xml = REXML::Document.new(self.xml)
        attribute.nil? ? xml.elements[path].text : xml.elements[path].attributes[attribute]
      end

      class ErbBinding < OpenStruct
        def get_binding
          return binding()
        end
      end

    end
  end
end
