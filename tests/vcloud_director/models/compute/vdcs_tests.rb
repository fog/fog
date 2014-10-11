require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | vdcs", ['vclouddirector', 'all']) do
  tests("#There is one or more vdc").returns(true){ organization.vdcs.size >= 1 }

  vdcs = organization.vdcs
  vdc = vdcs.first

  tests("Compute::VcloudDirector | vdc") do
    tests("#id").returns(String) { vdc.id.class }
    tests("#name").returns(String) { vdc.name.class }
    tests("#href").returns(String) { vdc.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.vdc+xml") { vdc.type }
  end

  tests("Compute::VcloudDirector | vdc", ['lazy load attrs']) do
    vdc.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { vdc.attributes[lazy_attr] }
    end
  end

  tests("Compute::VcloudDirector | vdc", ['load on demand']) do
    tests("#description is not loaded yet").returns(NonLoaded) { vdc.attributes[:description] }
    tests("#description is loaded on demand").returns(String) { vdc.description.class }
    tests("#description is now loaded").returns(true) { vdc.attributes[:description] != NonLoaded }
  end

  tests("Compute::VcloudDirector | vdc", ['lazy load attrs']) do
    lazy_attrs = vdc.lazy_load_attrs
    lazy_attrs.delete(:storage_capacity) if vcloud_director.api_version.to_f >= 5.1
    lazy_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is now loaded").returns(true) { vdc.attributes[lazy_attr] != NonLoaded }
    end
  end

  tests("Compute::VcloudDirector | vdc", ['get']) do
    tests("#get_by_name").returns(vdc.name) { vdcs.get_by_name(vdc.name).name }
    tests("#get").returns(vdc.id) { vdcs.get(vdc.id).id }
  end

  pending if Fog.mocking?

  # We should also be able to find this same vdc via Query API
  tests("Compute::VcloudDirector | vdcs", ['find_by_query']) do
    tests('we can retrieve :name without lazy loading').returns(vdc.name) do
      query_vdc = vdcs.find_by_query(:filter => "name==#{vdc.name}").first
      query_vdc.attributes[:name]
    end
    tests('by name').returns(vdc.name) do
      query_vdc = vdcs.find_by_query(:filter => "name==#{vdc.name}").first
      query_vdc.name
    end
  end
end
