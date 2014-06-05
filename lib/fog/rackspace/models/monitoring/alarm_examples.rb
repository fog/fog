require 'fog/core/collection'
require 'fog/rackspace/models/monitoring/alarm_example'

module Fog
  module Rackspace
    class Monitoring
      class AlarmExamples < Fog::Collection
        model Fog::Rackspace::Monitoring::AlarmExample

        def all
          data = service.list_alarm_examples.body['values']
          load(data)
        end

        def get(alarm_example_id)
          data = service.get_alarm_example(alarm_example_id).body
          new(data)
        rescue Fog::Rackspace::Monitoring::NotFound
          nil
        end

        def evaluate(alarm_example_id, options={})
          data = service.evaluate_alarm_example(alarm_example_id, options).body
          new(data)
        end
      end
    end
  end
end
