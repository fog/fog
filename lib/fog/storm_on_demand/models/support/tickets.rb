require 'fog/core/collection'
require 'fog/storm_on_demand/models/support/ticket'

module Fog
  module Support
    class StormOnDemand

      class Tickets < Fog::Collection
        model Fog::Support::StormOnDemand::Ticket

        def create(options)
          ticket = service.create_ticket(options).body
          new(ticket)
        end

        def get(ticket_id, secid)
          service.get_ticket_details(:id => ticket_id, :secid => secid).body
        end

        def all(options={})
          tickets = service.list_tickets(options).body['items']
          load(tickets)
        end

        def types
          service.list_ticket_types.body['types']
        end

      end

    end
  end
end
