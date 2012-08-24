module Fog
  module Terremark
    module Shared
      module Real
        include Common

        # Reserve requested resources and deploy vApp
        #
        # ==== Parameters
        # * vdc_id<~Integer> - Id of vDc to add internet service to
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
        def create_internet_service(vdc_id, name, protocol, port, options = {})
          unless options.has_key?('Enabled')
            options['Enabled'] = true
          end
          #Sample: "https://services.vcloudexpress.terremark.com/api/extensions/v1.6/vdc/3142/internetServices"
          path = vdcs.get(vdc_id).links.find { |item| item['name'] == 'Internet Services'}['href'].split(@host)[1]
          data = <<-DATA
          <CreateInternetServiceRequest xml:lang="en" xmlns="urn:tmrk:vCloudExpressExtensions-1.6" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <Name>#{name}</Name>
            <Protocol>#{protocol.upcase}</Protocol>
            <Port>#{port}</Port> 
            <Enabled>#{options['Enabled']}</Enabled>
            <Description>#{options['Description']}</Description>
            </CreateInternetServiceRequest>
            DATA
          response = request(
            :body     => data,
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/vnd.tmrk.vCloud.internetService+xml'},
            :method   => 'POST',
            :parser   => Fog::Parsers::Terremark::Shared::InternetService.new,
	    :path     => path,
            :override_path => true
          )
          response
        end

      end
    end
  end
end
