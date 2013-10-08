require 'fog/rackspace/models/auto_scale/group_builder'
require 'fog/rackspace/models/auto_scale/group'
require 'fog/rackspace/models/compute_v2/flavor'
require 'fog/rackspace/models/load_balancers/load_balancer'

Shindo.tests('Fog::Rackspace::AutoScale | group builder', ['rackspace', 'rackspace_autoscale']) do
  builder = Fog::Rackspace::AutoScale::GroupBuilder

  tests('#get_id') do
    tests('widget_id').returns(5) do
      builder.send(:get_id, 'widget', {:widget_id => 5, :noise => 3})
    end
    tests('widget').returns(5) do
      Fog::Rackspace::AutoScale::GroupBuilder.send(:get_id, 'widget', {:widget => 5, :noise => 3})
    end
    tests('Flavor object').returns(2) do
      flavor = Fog::Compute::RackspaceV2::Flavor.new(:id => 2)
      builder.send(:get_id, 'flavor', {:flavor => flavor, :noise => 3})
    end
  end

  tests('networks_to_hash').returns([{"uuid" => '00000000-0000-0000-0000-000000000000'}]) do
    builder.send(:networks_to_hash, ['00000000-0000-0000-0000-000000000000'])
  end

  tests('#build_server_template').returns(LAUNCH_CONFIG_OPTIONS["args"]["server"]) do
    attributes = {
      :server_name => "autoscale_server",
      :image => "0d589460-f177-4b0f-81c1-8ab8903ac7d8",
      :flavor => "2",
      :disk_config => "AUTO",
      :server_metadata => {
        "build_config" => "core",
        "meta_key_1" => "meta_value_1",
        "meta_key_2" => "meta_value_2"
      },
      :networks => ["11111111-1111-1111-1111-111111111111", "00000000-0000-0000-0000-000000000000"],
      :personality => [
        {
          "path" => "/root/.csivh",
          "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
        }
      ]
    }
    builder.send(:build_server_template, attributes)
  end

  tests('#load_balancer_to_hash') do
    lb_test_hash = {
      "port" =>  80,
      "loadBalancerId" => 1234
    }
    tests('hash').raises(ArgumentError, "Expected LoadBalancer") do
      builder.send(:load_balancer_to_hash, lb_test_hash)
    end
    tests('LoadBalancer').returns(lb_test_hash) do
      lb = Fog::Rackspace::LoadBalancers::LoadBalancer.new :port => 80, :id => 1234
      builder.send(:load_balancer_to_hash, lb)
    end
  end

  tests('build_load_balancers') do
    lb_test_hash = {
      "port" =>  80,
      "loadBalancerId" => 1234
    }
    tests('nil').returns(nil) do
      builder.send(:build_load_balancers, {})
    end
    tests('hash').returns([lb_test_hash]) do
      builder.send(:build_load_balancers, :load_balancers => [lb_test_hash])
    end
    tests('LoadBalancer').returns([lb_test_hash]) do
      lb = Fog::Rackspace::LoadBalancers::LoadBalancer.new :port => 80, :id => 1234
      builder.send(:build_load_balancers, :load_balancers => [lb])
    end
    tests('multiple lbs').returns([lb_test_hash, lb_test_hash]) do
      lb = Fog::Rackspace::LoadBalancers::LoadBalancer.new :port => 80, :id => 1234
      builder.send(:build_load_balancers, :load_balancers => [lb, lb])
    end
  end

  tests('build_server_launch_config') do
    tests('no launch_config_type').returns(nil) do
      builder.build_server_launch_config({:pancakes => true})
    end
    tests('wrong launch_config_type').returns(nil) do
      builder.build_server_launch_config({:launch_config_type => :something_else})
    end
    tests('valid launch config').returns(LAUNCH_CONFIG_OPTIONS["args"]) do
      attributes = {
        :server_name => "autoscale_server",
        :image => "0d589460-f177-4b0f-81c1-8ab8903ac7d8",
        :flavor => "2",
        :disk_config => "AUTO",
        :server_metadata => {
          "build_config" => "core",
          "meta_key_1" => "meta_value_1",
          "meta_key_2" => "meta_value_2"
        },
        :networks => ["11111111-1111-1111-1111-111111111111", "00000000-0000-0000-0000-000000000000"],
        :personality => [
          {
            "path" => "/root/.csivh",
            "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
          }
        ],
        :launch_config_type => :launch_server,
        :load_balancers => { "port" => 8080, "loadBalancerId" => 9099}
      }

      builder.build_server_launch_config(attributes).args
    end
  end

  tests('#build_group_config') do
    attributes = {
      :max_entities => 3,
      :min_entities => 0,
      :cooldown => 360,
      :name => "testscalinggroup198547",
      :metadata => {
        "gc_meta_key_2" => "gc_meta_value_2",
        "gc_meta_key_1" => "gc_meta_value_1"
      }
    }

    config = builder.build_group_config(attributes)
    returns(3) { config.max_entities }
    returns(0) { config.min_entities }
    returns(360) { config.cooldown }
    returns("testscalinggroup198547") { config.name }
    returns(attributes[:metadata]) { config.metadata }
  end

  tests('build') do
    pending if Fog.mocking?
    service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

    group = builder.build(service, :launch_config_type => :launch_server, :server_name => 'test', :cooldown => 500)
    returns(500) { group.group_config.cooldown }
    returns('test') { group.launch_config.args["server"]["name"]}
  end

end
