Shindo.tests('Fog::Compute::Brightbox::Real', ['brightbox']) do

  @bb = Fog::Compute::Brightbox::Real.new({})

  tests("#respond_to? :default_image").returns(true) do
    @bb.respond_to?(:default_image)
  end

end