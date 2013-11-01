require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class Network < Model

        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description
        attribute :is_inherited
        attribute :gateway
        attribute :netmask
        attribute :dns1
        attribute :dns2
        attribute :dns_suffix
        attribute :ip_ranges, :type => :array
        
        def destroy
                  requires :id
                  begin
                    response = service.delete_network(id)
                  rescue Fog::Compute::VcloudDirector::BadRequest => ex
                    Fog::Logger.debug(ex.message)
                    return false
                  end
                  service.process_task(response.body)
                end

      end
    end
  end
end
