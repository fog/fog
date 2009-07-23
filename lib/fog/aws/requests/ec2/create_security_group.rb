module Fog
  module AWS
    class EC2

      # Create a new security group
      #
      # ==== Parameters
      # * group_name<~String> - Name of the security group.
      # * group_description<~String> - Description of group.
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :request_id<~String> - Id of request
      #     * :return<~Boolean> - success?
      def create_security_group(name, description)
        request({
          'Action' => 'CreateSecurityGroup',
          'GroupName' => name,
          'GroupDescription' => CGI.escape(description)
        }, Fog::Parsers::AWS::EC2::Basic.new)
      end

    end
  end
end
