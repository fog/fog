Shindo.tests('Fog::Volume[:openstack] | quota requests', ['openstack']) do

  @tenant_id = Fog::Compute[:openstack].list_tenants.body['tenants'].first['id']
  @quota_set_format = {
    'volumes'   => Fog::Nullable::Integer,
    'gigabytes' => Fog::Nullable::Integer,
    'snapshots' => Fog::Nullable::Integer,
    'id'        => String
  }

  tests('success') do

    tests('#get_quota_defaults').formats({ 'quota_set' => @quota_set_format }) do
      Fog::Volume[:openstack].get_quota_defaults(@tenant_id).body
    end

    tests('#get_quota').formats(@quota_set_format) do
      @quota = Fog::Volume[:openstack].get_quota(@tenant_id).body['quota_set']
      @quota
    end

    tests('#update_quota') do

      new_values = @quota.merge({
        'volumes'   => @quota['volumes']/2,
        'snapshots' => @quota['snapshots']/2
      })

      succeeds do
        Fog::Volume[:openstack].update_quota(@tenant_id, new_values.clone)
      end

      returns(new_values, 'returns new values') do
        Fog::Volume[:openstack].get_quota(@tenant_id).body['quota_set']
      end

      # set quota back to old values
      succeeds do
        Fog::Volume[:openstack].update_quota(@tenant_id, @quota.clone)
      end

      # ensure old values are restored
      returns(@quota, 'old values restored') do
        Fog::Volume[:openstack].get_quota(@tenant_id).body['quota_set']
      end

    end

  end
end
