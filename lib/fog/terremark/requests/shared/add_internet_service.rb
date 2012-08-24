module Fog
  module Terremark
    module Shared
      module Real

        # Reserve requested resources and deploy vApp
        #
        # ==== Parameters
        # * ip_id<~Integer> - Id of ip to add service to
        # * name<~String> - Name of service
        # * protocol<~String> - Protocol of service
        # * port<~Integer> - Port of service
        # * options<~Hash>:
        #   * Enabled<~Boolean>: defaults to true
        #   * Description<~String>: optional description
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'endTime'<~String> - endTime of task
        #     * 'href'<~String> - link to task
        #     * 'startTime'<~String> - startTime of task
        #     * 'status'<~String> - status of task
        #     * 'type'<~String> - type of task
        #     * 'Owner'<~String> -
        #       * 'href'<~String> - href of owner
        #       * 'name'<~String> - name of owner
        #       * 'type'<~String> - type of owner
        def add_internet_service(ip_id, name, protocol, port, options = {})
          unless options.has_key?('Enabled')
            options['Enabled'] = true
          end
          data = <<-DATA
          <CreateInternetServiceRequest xml:lang="en" xmlns="urn:tmrk:vCloudExpressExtensions-1.6" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <Name>#{name}</Name>
            <Protocol>#{protocol.upcase}</Protocol>
            <Port>#{port}</Port> 
            <Enabled>#{options['Enabled']}</Enabled>
            <Description>#{options['Description']}</Description>
            </CreateInternetServiceRequest>
            DATA
          request(
            :body     => data,
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/xml'},
            :method   => 'POST',
            :parser   => Fog::Parsers::Terremark::Shared::InternetService.new,
            :path     => "api/extensions/v1.6/publicIp/#{ip_id}/internetServices",
            :override_path => true
          )
        end

      end
    end
  end
end
