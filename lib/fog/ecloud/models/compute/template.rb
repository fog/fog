module Fog
  module Compute
    class Ecloud
      class Template < Fog::Ecloud::Model
        identity :href

        attribute :name,              :aliases => :Name
        attribute :type,              :aliases => :Type
        attribute :other_links,       :aliases => :Links
        attribute :operating_system,  :aliases => :OperatingSystem
        attribute :description,       :aliases => :Description
        attribute :storage,           :aliases => :Storage
        attribute :network_adapters,  :aliases => :NetworkAdapters
        attribute :customization,     :aliases => :Customization
        attribute :licensed_software, :aliases => :LicensedSoftware

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
