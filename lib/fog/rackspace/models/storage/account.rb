require 'fog/core/model'

module Fog
  module Storage
    class Rackspace
      class Account < Fog::Model
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/View_Account_Info-d1e11995.html

        # @!attribute [rw] meta_temp_url_key
        # @return [String] The temporary URL key used to generate temporary access to files
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
        attribute :meta_temp_url_key, :aliases => 'X-Account-Meta-Temp-Url-Key'

        # @!attribute [r] container_count
        # @return [Integer] The number of containers in account
        attribute :container_count, :aliases => 'X-Account-Container-Count', :type => :integer

        # @!attribute [r] bytes_used
        # @return [Integer] The total number of bytes used by the account
        attribute :bytes_used, :aliases => 'X-Account-Bytes-Used', :type => :integer

        # @!attribute [r] object_count
        # @return [Integer] The total number of objects in the account
        attribute :object_count, :aliases => 'X-Account-Object-Count', :type => :integer

        # Saves account settings (meta_temp_url_key)
        # @return [Boolean] returns true if successfully updated
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def save
          service.post_set_meta_temp_url_key meta_temp_url_key
          true
        end

        # Reload account with latest data from Cloud Files
        # @return [Fog::Storage::Rackspace::Account] returns itself
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def reload
          response = service.head_containers
          merge_attributes response.headers
        end
      end
    end
  end
end
