module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_node_service_data(service_data)
          required_opts = [:name, :port, :enabled, :ip_address]
          unless required_opts.all? { |opt| service_data.key?(opt) }
            raise ArgumentError.new("Required Internet Service data missing: #{(required_opts - service_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def node_service_create(service_data)
          validate_node_service_data(service_data)

          request(
            :body => generate_node_service_request(service_data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => service_data[:uri],
            :parse => true
          )
        end

        private

        def generate_node_service_request(service_data)
          xml = Builder::XmlMarkup.new
          xml.CreateNodeService(:name => service_data[:name]) do
            xml.IpAddress(:href => service_data[:ip_address], :name => service_data[:ip_address].scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)[0])
            xml.Port service_data[:port]
            xml.Enabled service_data[:enabled]
            if service_data[:description]
              xml.Description service_data[:description]
            end
          end
        end
      end

      class Mock
        def node_service_create(service_data)
          validate_node_service_data(service_data)

          internet_service_id = service_data[:uri].match(/(\d+)/)[1]
          internet_service    = self.data[:internet_services][internet_service_id.to_i].dup
          network_id, ip_address_name     = service_data[:ip_address].match(/\/(\d+)\/(.*)$/).captures
          network = self.data[:networks][network_id.to_i]
          ip_addresses = network[:IpAddresses][:IpAddress]
          ip_addresses = ip_addresses.is_a?(Array) ? ip_addresses : [ip_addresses]
          ip_address = ip_addresses.find { |ip| ip[:name] == ip_address_name }

          service_id   = Fog::Mock.random_numbers(6).to_i
          service = {
            :href => "/cloudapi/ecloud/nodeservices/#{service_id}",
            :name => service_data[:name],
            :type => "application/vnd.tmrk.cloud.nodeService",
            :Links => {
              :Link => [
                Fog::Ecloud.keep(internet_service, :href, :name, :type),
              ],
            },
            :Protocol    => service_data[:protocol],
            :Port        => service_data[:port],
            :Enabled     => service_data[:enabled],
            :Description => service_data[:description],
            :IpAddress   => {
              :href => ip_address[:href],
              :name => ip_address[:name],
              :type => ip_address[:type],
              :Network => {
                :href => network[:href],
                :name => network[:name],
                :type => network[:type],
              },
            },
          }

          node_service_response = response(:body => service)

          service.merge!(:internet_service => internet_service)

          self.data[:node_services][service_id] = service

          node_service_response
        end
      end
    end
  end
end
