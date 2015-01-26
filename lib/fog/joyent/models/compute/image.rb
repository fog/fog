module Fog
  module Compute
    class Joyent
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :os
        attribute :version
        attribute :type
        attribute :description
        attribute :requirements
        attribute :homepage
        attribute :published_at, :type => :time
        attribute :public, :type => :boolean
        attribute :owner
        attribute :state
        attribute :tags
        attribute :eula
        attribute :acl
        attribute :created, :type => :time
        attribute :default, :type => :boolean
      end
    end
  end
end
