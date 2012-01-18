require 'fog/core/model'

module Fog
  module Compute
    class Bluebox

      class Image < Fog::Model

        identity :id
        
        attribute :block_id
        attribute :description
        attribute :public
        attribute :created_at, :aliases => 'created'
        
        def save
          requires :block_id
          
          data = connection.create_template(block_id, attributes)
          true
        end
        
        def destroy
          requires :id
          
          data = connection.destroy_template(id)
          true
        end
        
      end

    end
  end
end
