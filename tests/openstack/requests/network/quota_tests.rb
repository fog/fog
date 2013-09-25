Shindo.tests('Fog::Network[:openstack] | quota requests', ['openstack']) do

  @tenant_id = Fog::Compute[:openstack].list_tenants.body['tenants'].first['id']
  @quota_format = {
    'subnet'     => Fog::Nullable::Integer,
    'router'     => Fog::Nullable::Integer,
    'port'       => Fog::Nullable::Integer,
    'network'    => Fog::Nullable::Integer,
    'floatingip' => Fog::Nullable::Integer
  }

  @quotas_format = [{
    'subnet'     => Fog::Nullable::Integer,
    'router'     => Fog::Nullable::Integer,
    'port'       => Fog::Nullable::Integer,
    'network'    => Fog::Nullable::Integer,
    'floatingip' => Fog::Nullable::Integer,
    'tenant_id'  => Fog::Nullable::String
  }]

  tests('success') do

    tests('#get_quotas').formats({ 'quotas' => @quotas_format }) do
      Fog::Network[:openstack].get_quotas.body
    end

    tests('#get_quota').formats(@quota_format) do
      @quota = Fog::Network[:openstack].get_quota(@tenant_id).body['quota']
    end

    tests('#update_quota') do

      new_values = @quota.merge({
        'volumes'   => @quota['subnet']/2,
        'snapshots' => @quota['router']/2
      })

      succeeds do
        Fog::Network[:openstack].update_quota(@tenant_id, new_values.clone)
      end

      returns(new_values, 'returns new values') do
        Fog::Network[:openstack].get_quota(@tenant_id).body['quota']
      end

      # set quota back to old values
      succeeds do
        Fog::Network[:openstack].update_quota(@tenant_id, @quota.clone)
      end

      # ensure old values are restored
      returns(@quota, 'old values restored') do
        Fog::Network[:openstack].get_quota(@tenant_id).body['quota']
      end

    end

    tests('#delete_quota') do
      succeeds do
        Fog::Network[:openstack].delete_quota(@tenant_id)
      end
    end

  end
end
