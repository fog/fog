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
          if status == 'running'
            if progress.to_i == 0
              printf '.'
            else
              print " #{progress} %\r"
            end
          else
            puts "  #{status}"
          end
          status != 'running'
        end

        def cancel
          service.post_task_cancel(id)
        end

      end

    end
  end
end
