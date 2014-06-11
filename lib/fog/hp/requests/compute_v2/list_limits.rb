module Fog
  module Compute
    class HPV2
      class Real
        # List the limits on resources on a per tenant basis (absolute and rate limits)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'limits'<~Array>:
        #     * 'absolute'<~Hash> - List of absolute limits
        #       * 'maxImageMeta'<~String>            - the number of image metadata items allowed per instance
        #       * 'maxPersonality'<~String>          - the number of injected files that can be specified when a new VM instance is created
        #       * 'maxPersonalitySize'<~String>      - the maximum size of an injected file
        #       * 'maxSecurityGroupRules'<~String>   - the maximum number of rules in a security group
        #       * 'maxSecurityGroups'<~String>       - the maximum number of security groups
        #       * 'maxTotalKeypairs'<~String>        - the maximum number of key pairs
        #       * 'maxServerMeta'<~String>           - the number of server metadata items allowed per instance
        #       * 'maxTotalInstances'<~String>       - the maximum number of VM instances that can be created for the tenant
        #       * 'maxTotalRAMSize'<~String>         - the maximum number of megabytes of instance RAM for the tenant
        #       * 'maxTotalCores'<~String>           - the maximum number of cores per tenant
        #       * 'maxTotalFloatingIps'<~String>     - the maximum number of floating ips per tenant
        #       * 'totalRAMUsed'<~String>            - the total RAM used per tenant
        #       * 'totalInstancesUsed'<~String>      - the total number of instances used per tenant
        #       * 'totalFloatingIpsUsed'<~String>    - the total number of floating ips used per tenant
        #       * 'totalSecurityGroupsUsed'<~String> - the total number of instances used per tenant
        #       * 'totalCoresUsed'<~String>          - the total number of cores used per tenant
        #     * 'rate'<~Array> - List of rate limits on requests
        #       * 'regex'<~String>  - pattern to match the suburi
        #       * 'uri'<~String>    - pattern to mathc the uri
        #       * 'limit'<~Array>
        #       * 'next-available'<~String>  - next available time for request
        #       * 'remaining'<~String>       - the number of remaining requests
        #       * 'unit'<~String>            - the unit of time for the limit
        #       * 'value'<~String>           - the value of the limit
        #       * 'verb'<~String>            - the http request the limit applies to
        def list_limits
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'limits'
          )
        end
      end

      class Mock
        def list_limits
          response = Excon::Response.new
          limits = self.data[:limits].values

          response.status = 200
          response.body = { 'limits' => limits }
          response
        end
      end
    end
  end
end
