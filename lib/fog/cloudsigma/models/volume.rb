require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class Volume < Fog::CloudSigma::CloudsigmaModel
        identity :uuid

        attribute :status, :type => :string
        attribute :jobs
        attribute :name, :type => :string
        attribute :tags
        attribute :media, :type => :string
        attribute :mounted_on
        attribute :owner
        attribute :meta
        attribute :allow_multimount, :type => :boolean
        attribute :licenses
        attribute :affinities, :type => :array
        attribute :size, :type => :integer
        attribute :resource_uri, :type => :string

        def save
          if persisted?
            update
          else
            create
          end
        end

        def create
          requires :name, :size, :media
          data = attributes

          response = service.create_volume(data)
          new_attributes = response.body['objects'].first
          merge_attributes(new_attributes)
        end

        def update
          requires :identity, :name, :size, :media

          data = attributes()

          response = service.update_volume(identity, data)
          new_attributes = response.body
          merge_attributes(new_attributes)
        end

        def destroy
          requires :identity

          service.delete_volume(identity)

          true
        end

        alias_method :delete, :destroy

        def clone(clone_params={})
          requires :identity
          response = service.clone_volume(identity, clone_params)

          self.class.new(response.body['objects'].first)
        end
      end
    end
  end
end
