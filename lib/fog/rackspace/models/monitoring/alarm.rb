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

        def params(options={})
          h = {
            'label'                => label,
            'criteria'             => criteria,
            'notification_plan_id' => notification_plan_id,
          }.merge(options)
          h.reject {|key, value| value.nil?}
        end

        def save
          requires :notification_plan_id
          requires :entity_id

          if identity
            data = service.update_alarm(entity_id, identity, params)
          else
            options = params('check_type' => check_type, 'check_id' => check_id)
            data = service.create_alarm(entity_id, options)
            self.id = data.headers['X-Object-ID']
          end
          true
        end

        def destroy
          requires :id
          service.delete_alarm(entity.id,id)
        end

      end

    end
  end
end
