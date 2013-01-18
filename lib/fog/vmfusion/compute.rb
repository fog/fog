require 'fog/vmfusion'
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
          begin
            require 'fission'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end

      end
    end
  end
end
