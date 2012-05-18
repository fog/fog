require 'fog/ecloudv2/models/compute/internet_service'

module Fog
  module Compute
    class Ecloudv2
      class InternetServices < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::InternetService

        def all
          data = connection.get_internet_services(href).body[:InternetServices]
          if data.is_a?(Hash)
            load(data[:InternetService])
          elsif data.is_a?(String) && data.empty?
            load([])
          end
        end

        def get(uri)
          if data = connection.get_internet_service(uri)
            puts data.body.inspect
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create(options)
          options[:uri] = "/cloudapi/ecloud/internetServices/publicIps/#{public_ip_id}/action/createInternetService"
          options[:protocol] ||= "TCP"
          options[:enabled] ||= true
          options[:description] ||= ""
          options[:persistence] ||= {}
          options[:persistence][:type] ||= "None"
          data = connection.internet_service_create(options).body
          object = new(data)
        end

        def public_ip_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
