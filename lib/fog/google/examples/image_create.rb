def test
  connection = Fog::Compute.new({ :provider => "Google" })

  rawdisk = {
    :source         => nil, # 'http://some_valid_url_to_rootfs_tarball'
    :container_type => 'TAR',
  }

  # Can't test this unless the 'source' points to a valid URL
  return if rawdisk[:source].nil?

  img = connection.image.create(:name             => 'test-image',
                                :description      => 'Test image (via fog)',
                                :raw_disk         => rawdisk)

  img.reload # will raise if image was not saved correctly
end
