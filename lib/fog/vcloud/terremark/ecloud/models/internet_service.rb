module Fog
  module Vcloud
    module Terremark
      module Ecloud
        class InternetService < Fog::Vcloud::Model

          identity :href, :Href

          ignore_attributes :xmlns, :xmlns_i

          attribute :name, :aliases => :Name
          attribute :id, :aliases => :Id
          attribute :protocol, :aliases => :Protocol
          attribute :port, :aliases => :Port
          attribute :enabled, :aliases => :Enabled
          attribute :description, :aliases => :Description
          attribute :public_ip, :aliases => :PublicIpAddress
          attribute :timeout, :aliases => :Timeout
          attribute :redirect_url, :aliases => :RedirectURL
          attribute :monitor, :aliases => :Monitor

          def delete
            requires :href

            connection.delete_internet_service( href )
          end

          def save
            if new_record?
              result = connection.add_internet_service( collection.href, _compose_service_data )
              merge_attributes(result.body)
            else
              connection.configure_internet_service( href, _compose_service_data, _compose_ip_data )
            end
          end

          def nodes
            @nodes ||= Fog::Vcloud::Terremark::Ecloud::Nodes.new( :connection => connection, :href => href + "/nodeServices" )
          end

          private

          def _compose_service_data
            service_data = {}
            self.class.attributes.select{ |attribute| !send(attribute).nil? }.each { |attribute| service_data[attribute] = send(attribute).to_s }
            service_data
          end

          def _compose_ip_data
            if public_ip.nil?
              {}
            else
              { :id => public_ip[:Id], :href => public_ip[:Href], :name => public_ip[:Name] }
            end
          end

        end
      end
    end
  end
end


