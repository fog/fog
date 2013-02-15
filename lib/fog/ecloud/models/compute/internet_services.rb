require 'fog/ecloud/models/compute/internet_service'

module Fog
  module Compute
    class Ecloud
      class InternetServices < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::InternetService

        def all
          data = service.get_internet_services(href).body[:InternetServices]
          if data.is_a?(Hash)
            load(data[:InternetService])
          elsif data.is_a?(String) && data.empty?
            load([])
          end
        end

        def get(uri)
          data = service.get_internet_service(uri).body
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end

        def create(options)
          options[:uri] = "/cloudapi/ecloud/internetServices/publicIps/#{public_ip_id}/action/createInternetService"
          options[:protocol]           ||= "TCP"
          options[:enabled]            ||= true
          options[:description]        ||= ""
          options[:persistence]        ||= {}
          options[:persistence][:type] ||= "None"
          data = service.internet_service_create(options).body
          object = new(data)
        end

        def public_ip_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
