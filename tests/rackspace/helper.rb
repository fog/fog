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
          raise "ERROR! Server should have transitioned to '#{state}' not '#{current_state}'" if error_states.include?(current_state)
        end
        sleep 10 unless Fog.mocking?
      end
      sleep 30 unless Fog.mocking?
    end

    def rackspace_test_image_id(service) 
      # I chose to use the first Ubuntu because it will work with the smallest flavor and it doesn't require a license
      @image_id ||= Fog.credentials[:rackspace_image_id] || service.images.find {|img| img.name =~ /Ubuntu/ }.id
    end

    def rackspace_test_flavor_id(service)
      @flavor_id ||= Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id
    end

  end  
end
