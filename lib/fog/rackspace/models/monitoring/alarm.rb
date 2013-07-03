require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class Alarm < Fog::Rackspace::Monitoring::Base

        identity :id
        attribute :entity
        attribute :entity_id

        attribute :label
        attribute :criteria
        attribute :check_type
        attribute :check_id
        attribute :notification_plan_id

        def prep
          options = {
            'label'                => label,
            'criteria'             => criteria,
            'notification_plan_id' => notification_plan_id,
          }
          options = options.reject {|key, value| value.nil?}
          options
        end

        def save
          requires :notification_plan_id
          options = prep
          if identity then
            data = service.update_alarm(get_entity_id, identity, options)
          else
            options['check_type'] = check_type if check_type
            options['check_id'] = check_id if check_id
            data = service.create_alarm(get_entity_id, options)
          end
          true
        end

      end

    end
  end
end
