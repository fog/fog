require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | vapps", ['vclouddirector', 'all']) do
  pending if Fog.mocking?

  # unless there is atleast one vapp we cannot run these tests
  pending if vdc.vapps.empty?

  vapps = vdc.vapps
  vapp = vapps.first

  tests("Compute::VcloudDirector | vapp") do
    tests("#id").returns(String){ vapp.id.class }
    tests("#name").returns(String){ vapp.name.class }
    tests("#href").returns(String){ vapp.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.vApp+xml"){ vapp.type }
  end

  tests("Compute::VcloudDirector | vapp", ['lazy load attrs']) do
    vapp.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { vapp.attributes[lazy_attr] }
    end
  end

  tests("Compute::VcloudDirector | vapp", ['load on demand']) do
    tests("#description is not loaded yet").returns(NonLoaded) { vapp.attributes[:description] }
    tests("#description is loaded on demand").returns(String) { vapp.description.class }
    tests("#description is now loaded").returns(true) { vapp.attributes[:description] != NonLoaded }
  end

  tests("Compute::VcloudDirector | vapp", ['lazy load attrs']) do
    vapp.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is now loaded").returns(true) { vapp.attributes[lazy_attr] != NonLoaded }
    end
  end

  tests("Compute::VcloudDirector | vapp", ['get']) do
    tests("#get_by_name").returns(vapp.name) { vapps.get_by_name(vapp.name).name }
    tests("#get").returns(vapp.id) { vapps.get(vapp.id).id }
  end
end
