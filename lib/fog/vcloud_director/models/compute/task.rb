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
        attribute :expirity_time, :aliases => :expiryTime, :type => :time
        attribute :end_time, :aliases => :endTime, :type => :time
        attribute :error, :aliases => :Error
        attribute :result, :aliases => :Result
        attribute :progress, :aliases => :Progress
        
        
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
        
      end
    end
  end
end