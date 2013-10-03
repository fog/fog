module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/base'

        # Parameters for a captureVapp request.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/CaptureVAppParamsType.html
        #   vCloud API Documentation
        class CaptureVappParams < Base

          attr_reader :name, :source_href

          def initialize(name, source_href, options={})
            super options
            @name = name
            @source_href = source_href
          end

          # @api private
          # @return [Nokogiri::XML::Builder]
          def builder
            @builder ||= Nokogiri::XML::Builder.new do |xml|
              attrs = {:xmlns => 'http://www.vmware.com/vcloud/v1.5', :name => name}
              xml.CaptureVAppParams(attrs) {
                xml.Description options[:Description] || ''
                xml.Source(:href => source_href)
              }
            end
          end

        end
      end
    end
  end
end
