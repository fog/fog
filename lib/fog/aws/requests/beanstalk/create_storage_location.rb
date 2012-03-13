module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/create_storage_location'

        # Checks if the specified CNAME is available.
        #
        # ==== Options
        # * CNAMEPrefix<~String>: The prefix used when this CNAME is reserved
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_CheckDNSAvailability.html
        #
        def check_dns_availability()
          request({
                      'Operation'    => 'CheckDNSAvailability',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::CheckDNSAvailability.new
                  }.merge(options))
        end
      end
    end
  end
end
