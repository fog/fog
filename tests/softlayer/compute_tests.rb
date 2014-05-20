Shindo.tests('Fog::Compute[:softlayer]', ['softlayer']) do

  @test_service = Fog::Compute[:softlayer]

end

Shindo.tests('Fog::Compute.new', ['softlayer']) do

  tests("service options") do
    {
      :softlayer_api_url => "https://example.com",
      :softlayer_username => "user-12345",
      :softlayer_api_key => "password1234",
    }.each_pair do |option, sample|
      tests("recognises :#{option}").returns(true) do
        options = {:provider => "Softlayer"}
        options[option] = sample
        begin
          Fog::Compute.new(options)
          true
        rescue ArgumentError
          false
        end
      end
    end
  end
end
