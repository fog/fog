class Vcloud
  module Compute
    module TestSupport
      if Fog.mocking?
        def self.template
          'mock_template'
        end
      else
        def self.template
          template_name = ENV['VCLOUD_TEMPLATE']
          raise "Specify VApp template name in VCLOUD_TEMPLATE env var" unless template_name
          template_res = Vcloud.catalogs.item_by_name template_name
          raise "URI Not found for specified template - check template name" unless template_res
          template_res.href
        end
      end
    end

    module Formats
    end
  end
end
