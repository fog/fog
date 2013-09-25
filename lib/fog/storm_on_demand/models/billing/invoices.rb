require 'fog/core/collection'
require 'fog/storm_on_demand/models/billing/invoice'

module Fog
  module Billing
    class StormOnDemand

      class Invoices < Fog::Collection
        model Fog::Billing::StormOnDemand::Invoice

        def all(options={})
          invoices = service.list_invoices(options).body['items']
          load(invoices)
        end

        def get(invoice_id)
          invoice = service.get_invoice(:id => invoice_id).body
          new(invoice)
        end

        def next
          invoice = service.next_invoice.body
          new(invoice)
        end

      end

    end
  end
end
