require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class Task < Fog::Model

        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :status
        attribute :operation
        attribute :operation_name, :aliases => :operationName
        attribute :expiry_time, :aliases => :expiryTime, :type => :time
        attribute :end_time, :aliases => :endTime, :type => :time
        attribute :start_time, :aliases => :startTime, :type => :time
        attribute :error, :aliases => :Error
        attribute :result, :aliases => :Result
        attribute :progress, :aliases => :Progress, :type => :integer

        # Since 5.1
        attribute :operation_key, :aliases => :operationKey
        attribute :cancel_requested, :aliases => :cancelRequested, :type => :boolean
        attribute :service_namespace, :aliases => :serviceNamespace

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
