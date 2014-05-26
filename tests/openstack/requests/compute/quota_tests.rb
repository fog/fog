Shindo.tests('Fog::Compute[:openstack] | quota requests', ['openstack']) do

  @tenant_id = Fog::Compute[:openstack].list_tenants.body['tenants'].first['id']
  @quota_set_format = {
    'key_pairs' => Fixnum,
    'metadata_items' => Fixnum,
    'injected_file_content_bytes' => Fixnum,
    'injected_file_path_bytes' => Fixnum,
    'injected_files' => Fixnum,
    'ram' => Fixnum,
    'floating_ips' => Fixnum,
    'instances' => Fixnum,
    'cores' => Fixnum,
    'security_groups' => Fog::Nullable::Integer,
    'security_group_rules' => Fog::Nullable::Integer,
    'volumes' => Fog::Nullable::Integer,
    'gigabytes' => Fog::Nullable::Integer,
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
        'floating_ips' => @quota['floating_ips']/2,
        'cores' => @quota['cores']/2
      })

      succeeds do
        Fog::Compute[:openstack].update_quota(@tenant_id, new_values.clone)
      end

      returns(new_values, 'returns new values') do
        Fog::Compute[:openstack].get_quota(@tenant_id).body['quota_set']
      end

      # set quota back to old values
      succeeds do
        Fog::Compute[:openstack].update_quota(@tenant_id, @quota.clone)
      end

      # ensure old values are restored
      returns(@quota, 'old values restored') do
        Fog::Compute[:openstack].get_quota(@tenant_id).body['quota_set']
      end

    end

  end
end
