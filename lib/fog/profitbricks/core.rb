require 'fog/core'
#require 'fog/json'

module Fog
    module ProfitBricks
        extend Fog::Provider
        service(:compute, 'Compute')

        def self.construct_envelope(&block)
            namespaces = {
              'xmlns'         => '',
              'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/',
              'xmlns:ws'      => 'http://ws.api.profitbricks.com/'
            }

            Nokogiri::XML::Builder.new do |xml|
                xml[:soapenv].Envelope(namespaces) do
                    xml[:soapenv].Header
                    xml[:soapenv].Body(&block)
                end
            end
        end

        def self.to_boolean(string)
            return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
            return false if string == false || string.blank? || string =~ (/(false|f|no|n|0)$/i)
            raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
        end

        def self.parse_error(xml_fault)
            service_fault = {}

            Nokogiri::XML(xml_fault).xpath(
              '//ns2:ProfitbricksServiceFault',
              'xmlns:ns2' => 'http://ws.api.profitbricks.com/'
            ).each do |element|
                element.children.each do |child|
                    service_fault[child.name] = child.text
                end
            end
            puts "#{service_fault['faultCode']}: #{service_fault['message']}" 
        end
    end
end
