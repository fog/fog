provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | internet_services", [provider.to_s, "queries"]) do
  connection    = Fog::Compute[provider]
  organization = connection.organizations.first
  environment  = organization.environments.find { |e| e.name == config[:ecloud_environment_name] } || organization.environments.first
  public_ips   = environment.public_ips
  public_ip    = public_ips.find { |i| i.name == config[:ecloud_public_ip_name] } || public_ips.first
  @internet_services = public_ip.internet_services

  tests('#all').succeeds do
    returns(true, "is a collection") { @internet_services.is_a?(Fog::Compute::Ecloud::InternetServices) }
    if Fog.mocking?
      returns(false, "has services") { @internet_services.empty? }
    else
      true
    end
  end

  unless @internet_services.empty?
    tests('#get').succeeds do
      service = @internet_services.first
      fetched_service = connection.internet_services.get(service.href)
      returns(false, "service is not nil") { fetched_service.nil? }
      returns(true, "is an InternetService") { fetched_service.is_a?(Fog::Compute::Ecloud::InternetService) }
    end
  end
end
