require 'fog/ecloudv2/models/compute/backup_internet_service'

module Fog
  module Compute
    class Ecloudv2
      class BackupInternetServices < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::BackupInternetService

        def all
          data = connection.get_backup_internet_services(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_backup_internet_service(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def from_data(data)
          new(data)
        end

        def create(options)
          options[:uri] = href + "/action/createBackupInternetService"
          options[:enabled] ||= true
          data = connection.backup_internet_service_create(options)
          new(data)
        end

        def internet_service_id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
