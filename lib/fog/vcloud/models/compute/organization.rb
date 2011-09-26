module Fog
  module Vcloud
    class Compute
      class Organization < Fog::Vcloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :type
        attribute :full_name, :aliases => :FullName
        attribute :other_links, :aliases => :Link

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
            new( :connection => connection,
                 :href => href )
        end

        def servers
          @servers ||= Fog::Vcloud::Compute::Servers.
            new( :connection => connection,
                 :href => href )
        end

        def tasks
          load_unless_loaded!
          @tasks ||= Fog::Vcloud::Compute::Tasks.
            new( :connection => connection,
                 :href => other_links.find{|l| l[:type] == 'application/vnd.vmware.vcloud.tasksList+xml'}[:href] )
        end

        def vdcs
          @vdcs ||= Fog::Vcloud::Compute::Vdcs.
            new( :connection => connection,
                 :href => href )
        end

        private

        def collection_based_on_type(type, klass = nil)
          load_unless_loaded!
          test_links = other_links.kind_of?(Array) ? other_links : [other_links]
          if link = test_links.detect { |link| link[:type] == type }
            case type
            when "application/vnd.vmware.vcloud.catalog+xml"
              Fog::Vcloud::Compute::Catalog
            when "application/vnd.vmware.vcloud.vdc+xml"
              Fog::Vcloud::Compute::Vdc
            when "application/vnd.vmware.vcloud.network+xml"
              Fog::Vcloud::Compute::Network
            when "application/vnd.vmware.vcloud.network+xml"
              Fog::Vcloud::Compute::Network
            end.new( :connection => connection, :href => link[:href] )
          else
            [ ]
          end
        end
      end
    end
  end
end
