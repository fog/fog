require 'fog/model'

module Fog
  module Terremark
    module Shared

      class Server < Fog::Model

        identity :id

        attribute :name
        attribute :status

        def destroy
          requires :id
          data = connection.power_off(@id).body
          task = connection.tasks.new(data)
          task.wait_for { ready? }
          connection.delete_vapp(@id)
          true
        end

        # { '0' => 'Being created', '2' => 'Powered Off', '4' => 'Powered On'}
        def ready?
          @status == '2'
        end

        def reboot
          requires :id
          connection.reset(@id)
          true
        end

        def save
          requires :name
          data = connection.instantiate_vapp(@name)
          merge_attributes(data.body)
          task = connection.deploy_vapp(@id)
          task.wait_for { ready? }
          task = connection.power_on(@id)
          task.wait_for { ready? }
          true
        end

        private

        def href=(new_href)
          @id = new_href.split('/').last.to_i
        end

        def type=(new_type); end

      end

    end
  end
end
