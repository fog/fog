require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

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
        
        def refresh
          data = service.get_task(id).body
          data[:id] = data[:href].split('/').last
          service.tasks.new(data)
        end
        
      end
    end
  end
end