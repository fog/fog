class AWS
  module ELB
    module Formats

      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      LOAD_BALANCER = {
        "CreatedTime" => Time,
        "ListenerDescriptions" => Array,
        "HealthCheck" => {"HealthyThreshold" => Integer, "Timeout" => Integer, "UnhealthyThreshold" => Integer, "Interval" => Integer, "Target" => String},
        "Policies" => {"LBCookieStickinessPolicies" => Array, "AppCookieStickinessPolicies" => Array},
        "AvailabilityZones" => Array,
        "DNSName" => String,
        "LoadBalancerName"=> String,
        "Instances"=> Array
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
