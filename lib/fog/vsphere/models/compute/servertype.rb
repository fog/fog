module Fog
  module Compute
    class Vsphere
      class Servertype < Fog::Model
        identity :id

        attribute :family
        attribute :fullname
        attribute :datacenter
        attribute :interfacetypes

        def initialize(attributes={} )
          super defaults.merge(attributes)
        end

        def to_s
          id
        end

        def interfacetypes filters={}
          attributes[:interfacetypes] ||= service.interfacetypes({ :datacenter => datacenter, :servertype => self }.merge(filters))
        end

        private

        def defaults
          {
            :id=>"otherGuest64",
            :family=>"otherGuestFamily",
            :interfacetypes => nil,
          }
        end
      end
    end
  end
end
