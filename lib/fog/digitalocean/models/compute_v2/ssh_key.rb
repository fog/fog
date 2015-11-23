module Fog
  module Compute
    class DigitalOceanV2
      class SshKey < Fog::Model
        identity :id
        attribute :fingerprint
        attribute :public_key
        attribute :name

        def save
          requires :name, :public_key
          merge_attributes(service.create_ssh_key(name, public_key).body['ssh_key'])
          true
        end

        def destroy
          requires :id
          service.delete_ssh_key id
        end

        def update
          requires :id, :name
          data = service.update_server(id, name)
          merge_attributes(data.body['ssh_key'])
          true
        end

      end
    end
  end
end
