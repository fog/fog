require 'fog/core/model'

module Fog
  module Compute
    class Brightbox
      class Application < Fog::Model
        identity :id
        attribute :url
        attribute :name
        attribute :secret

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          options = {
            :name => name
          }.delete_if { |k, v| v.nil? || v == "" }
          data = service.create_application(options)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
