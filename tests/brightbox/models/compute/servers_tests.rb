Shindo.tests('Brightbox::Compute | servers collection', ['brightbox']) do

  image_id = Brightbox::Compute::TestSupport::IMAGE_IDENTIFER
  servers_tests(Brightbox[:compute], {:image_id => image_id}, false)

end
