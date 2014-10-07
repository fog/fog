Shindo.tests('Fog::Compute[:openstack] | limits requests', ['openstack']) do
  @rate_limit_format = {
    'regex' => String,
    'uri'   => String,
    'limit' => Array
  }

  @rate_limit_usage_format = {
    'next-available' => String,
    'unit'           => String,
    'verb'           => String,
    'remaining'      => Fixnum,
    'value'          => Fixnum
  }

  @absolute_limits_format = {
    'maxServerMeta'             => Fixnum,
    'maxTotalInstances'         => Fixnum,
    'maxPersonality'            => Fixnum,
    'maxImageMeta'              => Fixnum,
    'maxPersonalitySize'        => Fixnum,
    'maxSecurityGroupRules'     => Fixnum,
    'maxTotalKeypairs'          => Fixnum,
    'maxSecurityGroups'         => Fixnum,
    'maxTotalCores'             => Fixnum,
    'maxTotalFloatingIps'       => Fixnum,
    'maxTotalRAMSize'           => Fixnum,
    'totalCoresUsed'            => Fixnum,
    'totalRAMUsed'              => Fixnum,
    'totalInstancesUsed'        => Fixnum,
    'totalSecurityGroupsUsed'   => Fixnum,
    'totalFloatingIpsUsed'      => Fixnum
  }

  @limits_format = {
    'rate'     => Array,
    'absolute' => Hash
  }

  tests('success') do
    tests('#get_limits') do
      tests('format').formats(@limits_format) do
        Fog::Compute[:openstack].get_limits.body['limits']
      end

      tests('rate limit format').formats(@rate_limit_format) do
        Fog::Compute[:openstack].get_limits.body['limits']['rate'].first
      end

      tests('rate limit usage format').formats(@rate_limit_usage_format) do
        Fog::Compute[:openstack].get_limits.body['limits']['rate'].first['limit'].first
      end

      tests('absolute limits format').formats(@absolute_limits_format) do
        Fog::Compute[:openstack].get_limits.body['limits']['absolute']
      end
    end
  end
end
