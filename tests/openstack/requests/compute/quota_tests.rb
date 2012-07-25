Shindo.tests('Fog::Compute[:openstack] | quota requests', ['openstack']) do

  @tenant_id = Fog::Compute[:openstack].list_tenants.body['tenants'].first['id']
  @quota_set_format = {
    'metadata_items' => Fixnum,
    'injected_file_content_bytes' => Fixnum,
    'injected_files' => Fixnum,
    'gigabytes' => Fixnum,
    'ram' => Fixnum,
    'floating_ips' => Fixnum,
    'instances' => Fixnum,
    'volumes' => Fixnum,
    'cores' => Fixnum,
    'id' => String
  }

  tests('success') do
    tests('#get_quota_defaults').formats({ 'quota_set' => @quota_set_format }) do
      Fog::Compute[:openstack].get_quota_defaults(@tenant_id).body
    end

    tests('#get_quota').formats(@quota_set_format) do
      @quota = Fog::Compute[:openstack].get_quota(@tenant_id).body['quota_set']
      @quota
    end

    tests('#update_quota') do
      new_values = @quota.merge({
        'volumes' => @quota['volumes']/2,
        'cores' => @quota['cores']/2
      })

      succeeds do
        Fog::Compute[:openstack].update_quota(@tenant_id, new_values.clone)
      end

      returns(new_values, 'returns new values') do
        Fog::Compute[:openstack].get_quota(@tenant_id).body['quota_set']
      end
    end

  end
end

