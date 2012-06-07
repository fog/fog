require 'fog/ecloud/models/compute/support_ticket'

module Fog
  module Compute
    class Ecloud
      class SupportTickets < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::SupportTicket

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
