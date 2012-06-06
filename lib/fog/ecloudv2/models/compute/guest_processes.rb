require 'fog/ecloudv2/models/compute/guest_process'

module Fog
  module Compute
    class Ecloudv2
      class GuestProcesses < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::GuestProcess

        def all
          data = connection.get_guest_processes(href).body[:GuestProcess]
          load(data)
        end

        def get(uri)
          if data = connection.get_guest_process(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
