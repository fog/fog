Shindo.tests('Brightbox::Compute | server model', ['brightbox']) do

  image_id = Brightbox::Compute::TestSupport::IMAGE_IDENTIFER
  server_tests(Brightbox[:compute], {:image_id => image_id}, false)

end
