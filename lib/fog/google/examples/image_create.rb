require 'pry-nav'
require 'rubygems'
require 'fog'
def test
  connection = Fog::Compute.new({ :provider => "Google" })

  rawdisk = {
    :source         => 'https://www.googleapis.com/compute/v1/projects/graphite-demos/zones/us-central1-a/disks/fog-smoke-test-1406777369', # 'http://some_valid_url_to_rootfs_tarball'
    :container_type => 'TAR',
  }

  # Can't test this unless the 'source' points to a valid URL
  return if rawdisk[:source].nil?
binding.pry
  img = connection.images.create(:name             => 'test-image',
                                :description      => 'Test image (via fog)',
                                :raw_disk         => rawdisk)

  img.reload # will raise if image was not saved correctly
end
test
