Shindo.tests('Fog::Compute[:cloudstack] | snapshot requests', ['cloudstack']) do

  @snapshots_format = {
    'listsnapshotsresponse'  => {
      'count' => Integer,
      'snapshot' => [
        'id' => Integer,
        'account' => String,
        'domainid' => Integer,
        'domain' => String,
        'snapshottype' => String,
        'volumeid' => Integer,
        'volumename' => String,
        'volumetype' => String,
        'created' => String,
        'name' => String,
        'intervaltype' => String,
        'state' => String
      ]
    }
  }

  tests('success') do

    tests('#list_snapshots').formats(@snapshots_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_snapshots
    end

  end

end
