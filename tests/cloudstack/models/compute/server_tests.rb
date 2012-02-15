Shindo.tests("Fog::Compute[:cloudstack]") do

  @instance = Fog::Compute[:cloudstack].servers.new

  [:addresses, :flavor, :key_pair, :key_pair=, :volumes].each do |association|
    respondes_to(association)
  end

  @instance.save

  @instance.wait_for { ready? }

  @instance.destroy

end
