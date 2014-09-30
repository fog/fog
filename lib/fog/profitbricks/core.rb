require 'fog/core'

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
    end
end
