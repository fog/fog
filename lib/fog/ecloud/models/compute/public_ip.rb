module Fog
  module Compute
    class Ecloud
      class PublicIp < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :ip_type, :aliases => :IpType

        def internet_services
          @internet_services = Fog::Compute::Ecloud::InternetServices.new(:service => service, :href => href)
        end

        def environment_id
          other_links[:Link].find { |l| l[:type] == "application/vnd.tmrk.cloud.environment" }[:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
