require 'fog/core/model'

module Fog
  module Storage
    class Rackspace
      class Account < Fog::Model
        attribute :meta_temp_url_key, :aliases => 'X-Account-Meta-Temp-Url-Key'
        attribute :container_count, :aliases => 'X-Account-Container-Count', :type => :integer
        attribute :bytes_used, :aliases => 'X-Account-Bytes-Used', :type => :integer
        attribute :object_count, :aliases => 'X-Account-Object-Count', :type => :integer        
        
        def save
          service.post_set_meta_temp_url_key meta_temp_url_key
          true
        end
        
        def reload
          response = service.head_containers
          merge_attributes response.headers
        end
      end
    end
  end
end