module Fog
  module Compute
    class Ecloudv2
      class ApiKey < Fog::Ecloudv2::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :access_key, :aliases => :AccessKey
        attribute :status, :aliases => :Status
        attribute :private_key, :aliases => :PrivateKey

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
