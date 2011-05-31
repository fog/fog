class Vcloud
  module Compute
    module TestSupport
      def self.template
        ENV['VCLOUD_TEMPLATE'] || raise('Specify VApp template URI in VCLOUD_TEMPLATE env var')
      end
    end
    module Formats
    end
  end
end
