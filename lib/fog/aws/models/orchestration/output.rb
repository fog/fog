require 'fog/orchestration/models/output'

module Fog
  module Orchestration
    class AWS
      class Output < Fog::Orchestration::Output
        attribute :key, :aliases => ['OutputKey']
        attribute :value, :aliases => ['OutputValue']
        attribute :description, :aliases => ['OutputDescription']
      end
    end
  end
end
