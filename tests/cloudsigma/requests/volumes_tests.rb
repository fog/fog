Shindo.tests('Fog::Compute[:cloudsigma] | volume requests', ['cloudsigma']) do

  @volume_format = {
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
      'resource_uri' => Fog::Nullable::String,
      'size' => Integer,
      'status' => String,
      'storage_type' => Fog::Nullable::String,
      'tags' => Array
  }

  @volume_create_args = {:name => 'fogtest', :size => 1024**3, :media => :cdrom}

  tests('success') do

    tests("#create_volume(#@volume_create_args)").formats(@volume_format, false) do
      @resp_volume = Fog::Compute[:cloudsigma].create_volume(@volume_create_args).body['objects'].first
      @volume_uuid = @resp_volume['uuid']

      @resp_volume
    end

    volume = Fog::Compute[:cloudsigma].volumes.get(@volume_uuid)
    volume.wait_for { status == 'unmounted' }

    tests("#update_volume(#@volume_uuid)").formats(@volume_format, false) do
      @resp_volume['media'] = 'disk'
      @resp_volume = Fog::Compute[:cloudsigma].update_volume(@volume_uuid, @resp_volume).body

      @resp_volume
    end

    tests("#delete_volume(#@volume_uuid)").succeeds do
      resp = Fog::Compute[:cloudsigma].delete_volume(@volume_uuid)

      resp.body.empty? && resp.status == 204
    end

  end

  tests('failure') do
    tests("#get_volume(#@volume_uuid)|deleted|").raises(Fog::CloudSigma::Errors::NotFound) do
      Fog::Compute[:cloudsigma].get_volume(@volume_uuid).body
    end
  end

end
