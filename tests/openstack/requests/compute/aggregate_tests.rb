Shindo.tests('Fog::Compute[:openstack] | Compute aggregate requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @aggregate_format = {
    "availability_zone" => Fog::Nullable::String,
    "created_at"        => String,
    "deleted"           => Fog::Boolean,
    "deleted_at"        => Fog::Nullable::String,
    "id"                => Integer,
    "name"              => String,
    "updated_at"        => Fog::Nullable::String
  }

  @detailed_aggregate_format = @aggregate_format.merge({
    'hosts' => Array,
  })

  @metadata_aggregate_format = @aggregate_format.merge({
    "metadata"          => Hash,
  })

  tests('success') do
    tests('#create_aggregate').data_matches_schema({'aggregate' => @aggregate_format}) do
      aggregate_body = Fog::Compute[:openstack].create_aggregate('test_aggregate').body
      @aggregate = aggregate_body['aggregate']
      aggregate_body
    end

    tests('#list_aggregates').data_matches_schema({'aggregates' => [@metadata_aggregate_format]}) do
      Fog::Compute[:openstack].list_aggregates.body
    end

    tests('#update_aggregate').data_matches_schema({'aggregate' => @aggregate_format}) do
      aggregate_attributes = {'name' => 'test_aggregate2'}
      Fog::Compute[:openstack].update_aggregate(@aggregate['id'], aggregate_attributes).body
    end

    tests('#get_aggregate').data_matches_schema({'aggregate' => @detailed_aggregate_format}) do
      Fog::Compute[:openstack].get_aggregate(@aggregate['id']).body
    end

    tests('#add_aggregate_host').succeeds do
      @host_name =  Fog::Compute[:openstack].hosts.select{ |x| x.service_name == 'compute' }.first.host_name
      Fog::Compute[:openstack].add_aggregate_host(@aggregate['id'], @host_name)
    end

    tests('#remove_aggregate_host').succeeds do
      Fog::Compute[:openstack].remove_aggregate_host(@aggregate['id'], @host_name)
    end

    tests('#update_aggregate_metadata').succeeds do
      Fog::Compute[:openstack].update_aggregate_metadata(@aggregate['id'], {'test' => 'test', 'test2' => 'test2'})
    end

    tests('#delete_aggregate').succeeds do
      Fog::Compute[:openstack].delete_aggregate(@aggregate['id'])
    end
  end
end
