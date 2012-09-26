require 'fog/core/model'

module Fog
  module CDN
    class AWS

      class Invalidation < Fog::Model

        identity :id,                :aliases => 'Id'

        attribute :status,           :aliases => 'Status'
        attribute :create_time,      :aliases => 'CreateTime'
        attribute :caller_reference, :aliases => 'CallerReference'
        attribute :paths,            :aliases => 'Paths'

        def initialize(new_attributes={})
          super(invalidation_to_attributes(new_attributes))
        end

        def distribution
          @distribution
        end

        def ready?
          requires :id, :status
          status == 'Completed'
        end

        def save
          requires :paths, :caller_reference
          raise "Submitted invalidation cannot be submitted again" if identity
          response = connection.post_invalidation(distribution.identity, paths, caller_reference || Time.now.to_i.to_s)
          merge_attributes(invalidation_to_attributes(response.body))
          true
        end

        def destroy
          # invalidations can't be removed, but tests are requiring they do :)
          true
        end

        private

        def distribution=(dist)
          @distribution = dist
        end

        def invalidation_to_attributes(new_attributes={})
          invalidation_batch = new_attributes.delete('InvalidationBatch') || {}
          new_attributes['Paths'] = invalidation_batch['Path']
          new_attributes['CallerReference'] = invalidation_batch['CallerReference']
          new_attributes
        end

      end

    end
  end
end
