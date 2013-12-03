module Fog
  module Compute
    class Ecloud
      class Association < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :ip_address, :aliases => :IpAddress

        def delete
          data = service.rnat_associations_delete(href).body
          task = Fog::Compute::Ecloud::Tasks.new(:service => service, :href => href)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
