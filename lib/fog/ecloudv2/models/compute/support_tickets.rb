require 'fog/ecloudv2/models/compute/support_ticket'

module Fog
  module Compute
    class Ecloudv2
      class SupportTickets < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::SupportTicket

        def all
          data = connection.get_support_tickets(href).body[:TicketReference]
          load(data)
        end

        def get(uri)
          if data = connection.get_support_ticket(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
