require 'fog/core/collection'
require 'fog/aws/models/compute/spot_request'

module Fog
  module Compute
    class AWS
      class SpotRequests < Fog::Collection
      
        attribute :filters
        
        model Fog::Compute::AWS::SpotRequest

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = self.filters)
          unless filters.is_a?(Hash)
            Fog::Logger.warning("all with #{filters.class} param is deprecated, use all('spot-instance-request-id' => []) instead [light_black](#{caller.first})[/]")
            filters = {'spot-instance-request-id' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_spot_instance_requests(filters).body
          load(
            data['spotInstanceRequestSet'].map do |spot_instance_request|
              spot_instance_request['LaunchSpecification.Placement.AvailabilityZone'] = spot_instance_request['launchedAvailabilityZone']
              spot_instance_request['launchSpecification'].each do |name,value|
                spot_instance_request['LaunchSpecification.' + name[0,1].upcase + name[1..-1]] = value
              end
              spot_instance_request.merge(:groups => spot_instance_request['LaunchSpecification.GroupSet'])
              spot_instance_request 
            end.flatten
          )
        end

        def get(spot_request_id)
          if spot_request_id
            self.class.new(:connection => connection).all('spot-instance-request-id' => spot_request_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
