Shindo.tests('Fog::Compute[:brightbox] | firewall policy requests', ['brightbox']) do

  tests('success') do
    pending if Fog.mocking?

    create_options = {
      :name => "Fog test policy A"
    }

    tests("#create_firewall_policy(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_firewall_policy(create_options)
      @firewall_policy_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) { result }
    end

    tests("#list_firewall_policies()") do
      formats(Brightbox::Compute::Formats::Collection::FIREWALL_POLICIES, false) do
        Fog::Compute[:brightbox].list_firewall_policies
      end
    end

    tests("#get_firewall_policy('#{@firewall_policy_id}')") do
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) do
        Fog::Compute[:brightbox].get_firewall_policy(@firewall_policy_id)
      end
    end

    tests("#destroy_firewall_policy('#{@firewall_policy_id}')") do
      result = Fog::Compute[:brightbox].destroy_firewall_policy(@firewall_policy_id)
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) { result }
    end
  end
end
