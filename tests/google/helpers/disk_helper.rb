require 'securerandom'

# create a disk to be used in tests
def create_test_disk(connection, zone)
  zone = 'us-central1-a'
  random_string = SecureRandom.hex

  disk = connection.disks.create({
    :name => "fog-test-disk-#{random_string}",
    :size_gb => "10",
    :zone => zone,
    :source_image => "debian-7-wheezy-v20140408",
  })
  disk.wait_for { ready? }
  disk
end
