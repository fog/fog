require 'fog/orchestration/models/outputs'
require 'fog/rackspace/models/orchestration/output'

module Fog
  module Orchestration
    class Rackspace
      class Outputs < Fog::Orchestration::Outputs

        model Fog::Orchestration::Rackspace::Output

        def all(stack)
          stack.expand! unless stack.data
          load(
            stack.data['outputs'].map do |_output|
              Hash[
                _output.map do |k,v|
                  [k.sub('output_', ''), v]
                end
              ]
            end
          )
        end

      end
    end
  end
end
