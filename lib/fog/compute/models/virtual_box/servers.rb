require 'fog/core/collection'
require 'fog/compute/models/virtual_box/server'

module Fog
  module VirtualBox
    class Compute

      class Servers < Fog::Collection

        model Fog::VirtualBox::Compute::Server

        def all
          data = connection.machines.map do |machine|
            {
              :raw => machine
            }
          end
          load(data)
        end

        def bootstrap(new_attributes = {})
          raise 'Not Implemented'
          # server = create(new_attributes)
          # server.start
          # server.wait_for { ready? }
          # server.setup(:password => server.password)
          # server
        end

        def get(server_id)
          machine = connection.find_machine(server_id)
          new(:raw => machine)
        rescue ::VirtualBox::Exceptions::ObjectNotFoundException
          nil
        end

      end

    end
  end
end
