require 'fog/digitalocean/models/paging_collection'

module Fog
  module Compute
    class DigitalOceanV2
      class SshKeys < Fog::Compute::DigitalOceanV2::PagingCollection
        model Fog::Compute::DigitalOceanV2::SshKey

        # Returns list of ssh keys
        # @return [Fog::Compute::DigitalOceanV2::Sshkeys] Retrieves a list of ssh keys.
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-keys
        def all(filters={})
          data = service.list_ssh_keys(filters)
          links = data.body["links"]
          get_paged_links(links) 
          keys = data.body["ssh_keys"]
          load(keys)
        end

        # Returns ssh key
        # @return [Fog::Compute::DigitalOceanV2::Sshkeys] Retrieves a list of ssh keys.
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-key
        def get(id)
          key = service.get_ssh_key(id).body['ssh_key']
          new(key) if key
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
