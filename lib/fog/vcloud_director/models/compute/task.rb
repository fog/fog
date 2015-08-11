require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Task < Fog::Model
        identity  :id

        attribute :href
        attribute :type
        attribute :name
        attribute :end_time, :aliases => :endTime, :type => :time
        attribute :expiry_time, :aliases => :expiryTime, :type => :time
        attribute :operation
        attribute :operation_name, :aliases => :operationName
        attribute :start_time, :aliases => :startTime, :type => :time
        attribute :status
        attribute :description, :aliases => :Description
        attribute :error, :aliases => :Error
        attribute :progress, :aliases => :Progress, :type => :integer

        # Since 5.1
        attribute :operation_key, :aliases => :operationKey
        attribute :cancel_requested, :aliases => :cancelRequested, :type => :boolean
        attribute :service_namespace, :aliases => :serviceNamespace
        attribute :details, :aliases => :Details

        def ready?
          status == 'success'
        end

        def success?
          status == 'success'
        end

        def non_running?
          if @service.show_progress? && (@last_progress ||= 0) < 100
            if status == 'running' || status == 'queued'
              Fog::Formatador.redisplay_progressbar(progress, 100, :label => operation_name, :started_at => start_time)
              @last_progress = progress
            elsif status == 'success'
              Fog::Formatador.redisplay_progressbar(100, 100, :label => operation_name, :started_at => start_time)
              @last_progress = 100
            end
          end
          ! %w(running queued).include?(status)
        end

        def cancel
          service.post_cancel_task(id)
        end
      end
    end
  end
end
