require 'fog/cloudsigma/nested_model'
require 'fog/cloudsigma/models/volume'

module Fog
  module Compute
    class CloudSigma
      class Snapshot < Fog::CloudSigma::CloudsigmaModel
        identity :uuid

        attribute :allocated_size, :type => :integer
        attribute :drive
        attribute :grantees, :type => :array
        attribute :meta
        attribute :name, :type => :string
        attribute :owner
        attribute :permissions, :type => :array
        attribute :resource_uri, :type => :string
        attribute :status, :type => :string
        attribute :tags
        attribute :timestamp, :type => :string


        def save
          if persisted?
            update
          else
            create
          end
        end

        def create
          requires :name, :drive
          data = attributes

          response = service.create_snapshot(data)
          new_attributes = response.body['objects'].first
          merge_attributes(new_attributes)
        end

        def update
          requires :identity, :name

          data = attributes

          response = service.update_snapshot(identity, data)
          new_attributes = response.body
          merge_attributes(new_attributes)
        end

        def destroy
          requires :identity

          service.delete_snapshot(identity)

          true
        end

        alias_method :delete, :destroy

        def clone(clone_params={})
          requires :identity
          response = service.clone_snapshot(identity, clone_params)

          Volume.new(response.body)
        end

        alias_method :promote, :clone


        def available?
          status == 'available'
        end

      end
    end
  end
end
