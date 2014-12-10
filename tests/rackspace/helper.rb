LINKS_FORMAT = [{
  'href' => String,
  'rel' => String
}]

module Shindo
  class Tests
    def given_a_load_balancer_service(&block)
      @service = Fog::Rackspace::LoadBalancers.new
      instance_eval(&block)
    end

    def given_a_load_balancer(&block)
        @lb = @service.load_balancers.create({
            :name => ('fog' + Time.now.to_i.to_s),
            :protocol => 'HTTP',
            :port => 80,
            :virtual_ips => [{ :type => 'PUBLIC'}],
            :nodes => [{ :address => '1.1.1.1', :port => 80, :condition => 'ENABLED'}]
          })
        @lb.wait_for { ready? }
      begin
        instance_eval(&block)
      ensure
        @lb.wait_for { ready? }
        @lb.destroy
      end
    end

   def wait_for_request(description = "waiting", &block)
     return if Fog.mocking?
     tests(description) do
       Fog.wait_for &block
     end
   end

   def wait_for_server_deletion(server)
     return if Fog.mocking?
     begin
       @instance.wait_for { state = 'DELETED' }
     rescue Fog::Compute::RackspaceV2::NotFound => e
       # do nothing
     end
   end

    def wait_for_server_state(service, server_id, state, error_states=nil)
      current_state = nil
      until current_state == state
        current_state = service.get_server(server_id).body['server']['status']
        if error_states
          error_states = Array(error_states)
          if error_states.include?(current_state)
            Fog::Logger.warning caller
            Fog::Logger.warning "ERROR! Server should have transitioned to '#{state}' not '#{current_state}'"
            return
          end
        end
        sleep 10 unless Fog.mocking?
      end
      sleep 30 unless Fog.mocking?
    end

    def wait_for_volume_state(service, volume_id, state)
      current_state = nil
      until current_state == state
        current_state = service.get_volume(volume_id).body['volume']['status']
        if current_state == 'error'
          Fog::Logger.warning caller
          Fog::Logger.warning "Volume is in an error state!"
          return
        end
        sleep 10 unless Fog.mocking?
      end
    end

    def rackspace_test_image_id(service)
      image_id  = Fog.credentials[:rackspace_image_id]
      # I chose to use the first Ubuntu because it will work with the smallest flavor and it doesn't require a license
      image_id ||= Fog.mocking? ? service.images.first.id : service.images.find {|image| image.name =~ /Ubuntu/}.id # use the first Ubuntu image
    end

    def rackspace_test_flavor_id(service)
      @flavor_id ||= Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id
    end

    # After a server has been successfully deleted they are still being reported as attached to a cloud network
    # causing delete calls to fail. This method attempts to address that.
    def delete_test_network(network)
      return false if Fog.mocking? || network.nil?
      attempt = 0
      begin
        network.destroy
      rescue Fog::Compute::RackspaceV2::ServiceError => e
        if attempt == 3
           Fog::Logger.warning "Unable to delete #{network.label}"
          return false
        end
         Fog::Logger.warning "Network #{network.label} Delete Fail Attempt #{attempt}- #{e.inspect}"
        attempt += 1
        sleep 60
        retry
      end
      return true
    end
  end
end
