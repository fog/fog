module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/reboot_db_instance'

        # reboots a database instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_RebootDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to reboot
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def reboot_db_instance(instance_identifier)
          request({
            'Action'  => 'RebootDBInstance',
            'DBInstanceIdentifier' => instance_identifier,
            :parser   => Fog::Parsers::AWS::RDS::RebootDBInstance.new,
          })
        end

      end

      class Mock

        def reboot_db_instance(instance_identifier)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
