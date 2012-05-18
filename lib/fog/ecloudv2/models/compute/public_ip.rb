module Fog
  module Compute
    class Ecloudv2
      class PublicIp < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :ip_type, :aliases => :IpType

        def internet_services
          @internet_services = Fog::Compute::Ecloudv2::InternetServices.new(:connection => connection, :href => href)
        end
        
        def environment_id
          other_links[:Link].detect { |l| l[:type] == "application/vnd.tmrk.cloud.environment" }[:href].scan(/\d+/)[0]
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
