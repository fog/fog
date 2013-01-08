require 'fog/core/collection'
require 'fog/brightbox/models/compute/account'

module Fog
  module Compute
    class Brightbox

      class Accounts < Fog::Collection

        model Fog::Compute::Brightbox::Account

        def all
          data = service.list_accounts
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_account(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
