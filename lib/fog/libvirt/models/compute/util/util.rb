require 'nokogiri'
require 'erb'
require 'ostruct'
require 'securerandom'

module Fog
  module Compute
    module LibvirtUtil

      def xml_element(xml, path, attribute=nil)
        xml = Nokogiri::XML(xml)
        attribute.nil? ? (xml/path).first.text : (xml/path).first[attribute.to_sym]
      end

      def xml_elements(xml, path, attribute=nil)
         xml = Nokogiri::XML(xml)
         attribute.nil? ? (xml/path).map : (xml/path).map{|element| element[attribute.to_sym]}
      end

      def to_xml template_name = nil
        # figure out our ERB template filename
        erb = template_name || self.class.to_s.split("::").last.downcase
        path     = File.join(File.dirname(__FILE__), "..", "templates", "#{erb}.xml.erb")
        template = File.read(path)
        ERB.new(template, nil, '-').result(binding)
      end

      def randomized_name
        "fog-#{(SecureRandom.random_number*10E14).to_i.round}"
      end
    end
  end
end
