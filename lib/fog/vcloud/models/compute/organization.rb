module Fog
  module Vcloud
    class Compute
      class Organization < Fog::Vcloud::Model

        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :name
        attribute :description, :aliases => :Description
        attribute :type
        attribute :full_name, :aliases => :FullName

        def networks
          @networks ||= Fog::Vcloud::Compute::Networks.
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

        def catalogs
          @catalogs ||= Fog::Vcloud::Compute::Catalogs.
            new( :connection => connection,
                 :href => href )
        end

      end
    end
  end
end
