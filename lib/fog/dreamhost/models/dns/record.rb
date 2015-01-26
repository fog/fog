require 'fog/core/model'

module Fog
  module DNS
    class Dreamhost
      class Record < Fog::Model
        identity  :name, :aliases => 'record'

        attribute :value
        attribute :zone
        attribute :type
        attribute :editable
        attribute :account_id
        attribute :comment

        def destroy
          service.delete_record(name, type, value)
          true
        end

        def save
          requires :name, :type, :value

          data = service.create_record(name, type, value, comment).body
          merge_attributes(data)
          true
        end
      end
    end
  end
end
