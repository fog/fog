unless Fog.mocking?

  module Fog
    class Terremark

      # Get list of organizations
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'description'<~String> - Description of organization
      #     * 'links'<~Array> - An array of links to entities in the organization
      #     * 'name'<~String> - Name of organization
      def get_organizations
        request({
          :body     => '',
          :expects  => 200,
          :headers  => {
            'Authorization' => "Basic #{Base64.encode64("#{@terremark_username}:#{@terremark_password}").chomp!}"
          },
          :method   => 'POST',
          :parser   => Fog::Parsers::Terremark::GetOrganizations.new,
          :path     => 'login'
        })
      end

    end
  end

else

  module Fog
    class Terremark

      def get_organizations
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end

end
