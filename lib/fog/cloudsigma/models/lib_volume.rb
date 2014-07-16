require 'fog/core/model'

module Fog
  module Compute
    class CloudSigma
      class LibVolume < Fog::Model
        identity :uuid

        attribute :mounted_on
        attribute :licenses
        attribute :meta
        attribute :owner
        attribute :affinities
        attribute :image_format, :type => :string
        attribute :size, :type => :integer
        attribute :category
        attribute :image_type, :type => :string
        attribute :media, :type => :string
        attribute :state, :type => :string
        attribute :status, :type => :string
        attribute :jobs
        attribute :description, :type => :string
        attribute :tags
        attribute :favourite, :type => :boolean
        attribute :paid, :type => :boolean
        attribute :allow_multimount, :type => :boolean
        attribute :install_notes, :type => :string
        attribute :arch, :type => :string
        attribute :name, :type => :string
        attribute :url, :type => :string
        attribute :os, :type => :string
        attribute :resource_uri, :type => :string

        def reload
          requires :identity
          collection.get(identity)
        end

        def clone(clone_params={})
          requires :identity
          response = service.clone_volume(identity, clone_params)

          self.class.new(response.body['objects'].first)
        end
      end
    end
  end
end
