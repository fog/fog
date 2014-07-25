require 'fog/compute/models/server'

module Fog
    module Compute
        class ProfitBricks
            class Server < Fog::Compute::Server
                identity  :id
                attribute :name

                def save
                    requires :data_center_id, :name, :image_id, :size
                    data = service.create_server(
                        data_center_id, boot_from_storage_id, cores,
                        server_name, ram, internet_access
                    )
                    merge_attributes(data.body['createServerResponse'])
                    true
                end 

                def update
                    requires :id
                    service.stop_server self.id
                end

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

                def destroy
                    requires :id
                    service.delete_server self.id
                end
            end
        end
    end
end
