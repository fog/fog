require 'fog/core/model'
require 'fog/rackspace/models/monitoring/base'

module Fog
  module Rackspace
    class Monitoring
      class Notification < Fog::Rackspace::Monitoring::Base
        identity :id

        attribute :label
        attribute :details
        attribute :type

        def params
          options = {
            'label'     => label,
            'details'   => details,
            'type'      => type,
          }
          options.reject {|key, value| value.nil?}
        end

        def save
          if identity
            data = service.update_notification(identity, params)
          else
            data = service.create_notification(params)
            self.id = data.headers['X-Object-ID']
          end
          true
        end

        def destroy
          requires :id
          service.delete_notification(id)
        end
      end
    end
  end
end
