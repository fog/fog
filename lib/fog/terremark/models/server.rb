require 'fog/model'

module Fog
  module Terremark

    class Server < Fog::Model

      identity :id

      attribute :name
      attribute :status

      def destroy
        requires :id
        task = connection.tasks.new(connection.power_off(@id).body)
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
        deploy_task = connection.tasks.new(connection.deploy_vapp(@id).body)
        deploy_task.wait_for { ready? }
        power_on_task = connection.tasks.new(connection.power_on(@id).body)
        power_on_task.wait_for { ready? }
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
