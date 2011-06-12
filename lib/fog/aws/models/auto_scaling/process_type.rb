require 'fog/core/model'
module Fog
  module AWS
    class AutoScaling

      class ProcessType < Fog::Model

        identity :id, :aliases => 'ProcessName'

      end
    end
  end
end
