require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand
      class Image < Fog::Model
        identity :id
        attribute :accnt
        attribute :features
        attribute :hv_type
        attribute :name
        attribute :source_hostname
        attribute :source_uniq_id
        attribute :template
        attribute :template_description
        attribute :time_taken

        def destroy
          requires :identity
          service.delete_image(:id => identity)
          true
        end

        def update(options={})
          requires :identity
          service.update_image({:id => identity}.merge!(options)).body
        end

        def restore(options={})
          requires :identity
          service.restore_image({:id => identity}.merge!(options))
          true
        end
      end
    end
  end
end
