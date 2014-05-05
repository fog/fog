Shindo.tests('Fog::Compute[:brightbox] | database snapshot requests', ['brightbox']) do
  pending if Fog.mocking?

  service = Fog::Compute[:brightbox]

  tests('success') do

    # Create a Database Server, then snapshot it
    database_server = service.database_servers.create
    database_server.wait_for { ready? }
    service.snapshot_database_server(database_server.id)

    tests("#list_database_snapshots") do
      result = service.list_database_snapshots
      data_matches_schema(Brightbox::Compute::Formats::Collection::DATABASE_SNAPSHOTS, {:allow_extra_keys => true}) { result }
      @database_snapshot_id = result.last["id"]
    end

    # Can't delete the server until snapshot is finished
    service.database_snapshots.get(@database_snapshot_id).wait_for { ready? }
    database_server.destroy

    tests("#get_database_snapshot('#{@database_snapshot_id}')") do
      result = service.get_database_snapshot(@database_snapshot_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SNAPSHOT, {:allow_extra_keys => true}) { result }
    end

    update_options = {
      :name => "New name"
    }
    tests("#update_database_snapshot('#{@database_snapshot_id}', update_options)") do
      result = service.update_database_snapshot(@database_snapshot_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SNAPSHOT, {:allow_extra_keys => true}) { result }
    end

    tests("#destroy_database_snapshot('#{@database_snapshot_id}')") do
      result = service.destroy_database_snapshot(@database_snapshot_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SNAPSHOT, {:allow_extra_keys => true}) { result }
    end
  end

  tests('failure') do
    tests("get_database_snapshot").raises(Excon::Errors::NotFound) do
      service.get_database_snapshot("dbs-00000")
    end
  end
end
