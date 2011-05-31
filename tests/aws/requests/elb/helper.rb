class AWS
  module ELB
    module Formats

      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      LOAD_BALANCER = {
        "AvailabilityZones" => Array,
        "CanonicalHostedZoneName" => String,
        "CanonicalHostedZoneNameID" => String,
        "CreatedTime" => Time,
        "DNSName" => String,
        "HealthCheck" => {"HealthyThreshold" => Integer, "Timeout" => Integer, "UnhealthyThreshold" => Integer, "Interval" => Integer, "Target" => String},
        "Instances" => Array,
        "ListenerDescriptions" => Array,
        "LoadBalancerName" => String,
        "Policies" => {"LBCookieStickinessPolicies" => Array, "AppCookieStickinessPolicies" => Array},
        "SourceSecurityGroup" => {"GroupName" => String, "OwnerAlias" => String},
      }

      CREATE_LOAD_BALANCER = BASIC.merge({
        'CreateLoadBalancerResult' => { 'DNSName' => String }
      })

      DESCRIBE_LOAD_BALANCERS = BASIC.merge({
        'DescribeLoadBalancersResult' => {'LoadBalancerDescriptions' => [LOAD_BALANCER]}
      })

      CONFIGURE_HEALTH_CHECK = BASIC.merge({
        'ConfigureHealthCheckResult' => {'HealthCheck' => {
        'Target' => String,
        'Interval' => Integer,
        'Timeout' => Integer,
        'UnhealthyThreshold' => Integer,
        'HealthyThreshold' => Integer
      }}
      })

      DELETE_LOAD_BALANCER = BASIC.merge({
        'DeleteLoadBalancerResult' =>  NilClass
      })

    end
  end
end
