def test
  connection = Fog::Compute.new({ :provider => "Google" })

  # puts 'Listing snapshots...'
  # puts '---------------------------------'
  snapshots = connection.snapshots.all
  raise 'Could not LIST the snapshots' unless snapshots
  # puts snapshots.inspect

  # puts 'Fetching a single snapshot...'
  # puts '------------------------------------------------'
  snap = snapshots.first
  if !snap.nil?
    snap = connection.snapshots.get(snap)
    raise 'Could not GET the snapshot' unless snap
    # puts snap.inspect
  end
end
