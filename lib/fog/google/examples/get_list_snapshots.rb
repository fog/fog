def test

  connection = Fog::Compute.new({ :provider => "Google" })

  # puts 'Listing images in all projects...'
  # puts '---------------------------------'
  snapshots = connection.snapshots.all
  raise 'Could not LIST the snapshots' unless snapshots
  # puts snapshots.inspect

  snap = snapshots.first
  # puts 'Fetching a single image from a global project...'
  # puts '------------------------------------------------'
  if !snap.nil?
    snap = connection.snapshots.get(snap)
    raise 'Could not GET the snapshot' unless snap
    # puts snap.inspect
  end

end
