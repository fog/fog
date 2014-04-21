# create a disk to be used in tests
def create_test_disk(connection, zone)
  zone = 'us-central1-a'
  disk = connection.disks.create({
    :name => "fogservername",
    :size_gb => "2",
    :zone => zone,
    :source_image => "debian-7-wheezy-v20140408",
  })
  disk.wait_for { ready? }
  disk
end
