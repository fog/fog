require File.expand_path(File.join(File.dirname(__FILE__), '..', 'vmfusion'))
require 'fog/compute'

module Fog
  module Compute
    class Vmfusion < Fog::Service

      model_path 'fog/vmfusion/models/compute'
      model       :server
      collection  :servers

      class Mock

        def initialize(options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def initialize(options={})
          require 'fission'
        end

      end
    end
  end
end
