require 'fog/ecloud/models/compute/public_ip'

module Fog
  module Compute
    class Ecloud
      class PublicIps < Fog::Ecloud::Collection

        undef_method :create

        attribute :href, :aliases => :Href

        model Fog::Compute::Ecloud::PublicIp

        #get_request :get_public_ip
        #vcloud_type "application/vnd.tmrk.ecloud.publicIp+xml"
        #all_request lambda { |public_ips| public_ips.connection.get_public_ips(public_ips.href) }

        def all
          check_href!(:message => "the Public Ips href of the Vdc you want to enumerate")
          if data = connection.get_public_ips(href).body[:PublicIPAddress]
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_public_ip(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
