# create a disk to be used in tests
def create_test_disk(connection, zone)
  zone = 'us-central1-a'
  disk = connection.disks.create({
    :name => "fog-test-disk-#{Time.now.to_i}",
    :size_gb => "10",
    :zone_name => zone,
    :source_image => "debian-7-wheezy-v20131120",
  })
  disk.wait_for { ready? }
  disk
end
