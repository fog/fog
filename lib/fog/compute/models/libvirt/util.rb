require "rexml/document"
require 'erb'

module Fog
  module Compute
    module LibvirtUtil
      # return templated xml to be used by libvirt
      def template_xml
        ERB.new(template, nil, '-').result(binding)
      end

      private
      # template file that contain our xml template
      def template
        File.read("#{File.dirname(__FILE__)}/templates/#{template_path}")
      rescue => e
        warn "failed to read template #{template_path}: #{e}"
      end

      # finds a value from xml
      def document path, attribute=nil
        return nil if new?
        xml = REXML::Document.new(@xml_desc)
        attribute.nil? ? xml.elements[path].text : xml.elements[path].attributes[attribute]
      end
    end
  end
end