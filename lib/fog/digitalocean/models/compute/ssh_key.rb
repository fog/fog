module Fog
  module Compute
    class DigitalOcean
      class SshKey < Fog::Model
        identity :id

        attribute :name
        attribute :ssh_pub_key

        def save
          requires :name, :ssh_pub_key

          merge_attributes(service.create_ssh_key(name, ssh_pub_key).body['ssh_key'])
          true
        end

        def destroy
          requires :id

          service.destroy_ssh_key id
          true
        end
      end
    end
  end
end
