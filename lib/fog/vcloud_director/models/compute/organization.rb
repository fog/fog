require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Organization < Model
        identity  :id

        attribute :name
        attribute :type
        attribute :href
        attribute :description, :aliases => :Description
        attribute :full_name, :aliases => :FullName

        def vdcs
          requires :id
          service.vdcs(:organization => self)
        end

        def catalogs
          requires :id
          service.catalogs(:organization => self)
        end

        def networks
          requires :id
          service.networks(:organization => self)
        end

        def tasks
          requires :id
          service.tasks(:organization => self)
        end
      end
    end
  end
end
