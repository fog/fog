Shindo.tests('Fog::Compute[:cloudsigma] | snapshot requests', ['cloudsigma']) do

  @snapshot_format = {
      'uuid' => String,
      'allocated_size' => Fog::Nullable::Integer,
      'drive' => Fog::Nullable::Hash,
      'meta' => Fog::Nullable::Hash,
      'name' => String,
      'owner' => Fog::Nullable::Hash,
      'resource_uri' => Fog::Nullable::String,
      'status' => String,
      'tags' => Array,
      'timestamp' => String
  }
  @promoted_volume_format = {
      'uuid' => String,
      'affinities' => Array,
      'allow_multimount' => Fog::Boolean,
      'jobs' => Array,
      'licenses' => Array,
      'media' => String,
      'meta' => Fog::Nullable::Hash,
      'mounted_on' => Array,
      'name' => String,
      'owner' => Fog::Nullable::Hash,
      'resource_uri' => Fog::Nullable::Hash, # this field's type is the only difference from volume format
      'size' => Integer,
      'status' => String,
      'storage_type' => String,
      'tags' => Array
  }

  @volume = Fog::Compute[:cloudsigma].volumes.create(:name => 'fogsnapshottest', :size => 1024**3, :media => :disk)
  @volume.wait_for { available? } unless Fog.mocking?
  @snapshot_create_args = {:name => 'fogtest', :drive => @volume.uuid}

  tests('success') do

    tests("#create_snapshot(#@snapshot_create_args)").formats(@snapshot_format, false) do
      @resp_snapshot = Fog::Compute[:cloudsigma].create_snapshot(@snapshot_create_args).body['objects'].first
      @snapshot_uuid = @resp_snapshot['uuid']

      @resp_snapshot
    end

    @snapshot = Fog::Compute[:cloudsigma].snapshots.get(@snapshot_uuid)
    @snapshot.wait_for { available? }

    tests("#update_snapshot(#@snapshot_uuid)").formats(@snapshot_format, false) do
      @resp_snapshot['name'] = 'fogtest_renamed'
      @resp_snapshot = Fog::Compute[:cloudsigma].update_snapshot(@snapshot_uuid, @resp_snapshot).body

      @resp_snapshot
    end

    # promote snapshot to a drive
    tests("#promote_snapshot(#@snapshot_uuid)").formats(@promoted_volume_format, false) do
      @resp_promoted_volume = Fog::Compute[:cloudsigma].clone_snapshot(@snapshot_uuid).body

      @resp_promoted_volume
    end
    # cleanup
    @promoted_volume = Fog::Compute[:cloudsigma].volumes.get(@resp_promoted_volume['uuid'])
    @promoted_volume.wait_for { available? } unless Fog.mocking?
    @promoted_volume.destroy

    tests("#delete_snapshot(#@snapshot_uuid)").succeeds do
      resp = Fog::Compute[:cloudsigma].delete_snapshot(@snapshot_uuid)

      resp.body.empty? && resp.status == 204
    end

  end

  tests('failure') do
    tests("#get_snapshot(#@snapshot_uuid)|deleted|").raises(Fog::CloudSigma::Errors::NotFound) do
      Fog::Compute[:cloudsigma].get_snapshot(@snapshot_uuid).body
    end
  end

  @volume.destroy

end
