require 'fog/compute/models/server'

module Fog
    module Compute
        class ProfitBricks
            class Server < Fog::Compute::Server
                identity  :id
                attribute :name

                def reboot
                    requires :id
                    service.reset_server self.id
                end 

                def start
                    requires :id
                    service.start_server self.id
                end 

                def stop
                    requires :id
                    service.stop_server self.id
                end 

                def update
                    requires :id
                    service.update_server self.id
                end 

                def destroy
                    requires :id
                    service.delete_server self.id
                end 
            end
        end
    end
end
