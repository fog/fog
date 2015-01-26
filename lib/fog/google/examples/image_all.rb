def test
  connection = Fog::Compute.new({ :provider => "Google" })

  # If this doesn't raise an exception, everything is good.
  connection.images.all
end
