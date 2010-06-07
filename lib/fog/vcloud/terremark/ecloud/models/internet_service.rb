require 'fog/model'

module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class InternetService < Fog::Vcloud::Model

          identity :href

          attribute :name
          attribute :id
          attribute :type
          attribute :protocol
          attribute :port
          attribute :enabled
          attribute :description
          attribute :public_ip
          attribute :timeout
          attribute :url_send_string
          attribute :http_header

          attr_accessor :new

          def delete
            requires :href

            connection.delete_internet_service( self.href )
            collection.reload
          end

          def save
            if new?
              result = connection.add_internet_service( collection.href, _compose_service_data )
              self.href = result.body.href
              self.reload
              @new = false
            else
              connection.configure_internet_service( self.href, _compose_service_data, _compose_ip_data )
            end
          end

          def new?
            @new ||= false
          end

          private

          def _compose_service_data
            service_data = {}
            self.class.attributes.select{ |attribute| !attribute.nil? }.each { |attribute| service_data[attribute] = send(attribute).to_s }
            service_data
          end

          def _compose_ip_data
            if public_ip.nil?
              {}
            else
              { :id => self.public_ip.id, :href => self.public_ip.href.to_s, :name => self.public_ip.name }
            end
          end

        end
      end
    end
  end
end


