require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class Alarm < Fog::Rackspace::Monitoring::Base
        identity :id
        attribute :entity, :aliases => 'entity_id'
        attribute :check, :aliases => 'check_id'

        attribute :disabled, :type => :boolean
        attribute :label
        attribute :criteria
        attribute :check_type
        attribute :notification_plan_id

        def entity=(obj)
         attributes[:entity] = obj.is_a?(String) ? Entity.new(:id => obj) : obj
        end

        def check=(obj)
          attributes[:check] = obj.is_a?(String) ? Check.new(:id => obj) : obj
        end

        def params(options={})
          h = {
            'disabled'             => disabled,
            'label'                => label,
            'criteria'             => criteria,
            'notification_plan_id' => notification_plan_id,
          }.merge(options)
          h.reject {|key, value| value.nil?}
        end

        def save
          requires :notification_plan_id
          requires :entity
          requires :check

          if identity
            service.update_alarm(entity.id, identity, params)
          else
            options = params('check_type' => check_type, 'check_id' => check.id)
            data = service.create_alarm(entity.id, options)
            self.id = data.headers['X-Object-ID']
          end
          true
        end

        def destroy
          requires :id
          service.delete_alarm(entity.id, id)
        end
      end
    end
  end
end
