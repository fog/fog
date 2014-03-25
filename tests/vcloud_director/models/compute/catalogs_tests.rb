require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | catalogs", ['vclouddirector', 'all']) do
  pending if Fog.mocking?

  pending if organization.catalogs.empty?
  catalogs = organization.catalogs
  tests("#There is one or more catalog").returns(true) { catalogs.size >= 1 }
  catalog = catalogs.first

  tests("Compute::VcloudDirector | catalog") do
    tests("#id").returns(String){ catalog.id.class }
    tests("#name").returns(String){ catalog.name.class }
    tests("#href").returns(String){ catalog.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.catalog+xml"){ catalog.type }
  end

  tests("Compute::VcloudDirector | catalog", ['lazy load attrs']) do
    catalog.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { catalog.attributes[lazy_attr] }
    end
  end

  tests("Compute::VcloudDirector | catalog", ['load on demand']) do
    tests("#description is not loaded yet").returns(NonLoaded) { catalog.attributes[:description] }
    tests("#description is loaded on demand").returns(String) { catalog.description.class }
    tests("#description is now loaded").returns(true) { catalog.attributes[:description] != NonLoaded }
  end

  tests("Compute::VcloudDirector | catalog", ['lazy load attrs']) do
    catalog.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is now loaded").returns(true) { catalog.attributes[lazy_attr] != NonLoaded }
    end
  end

  tests("Compute::VcloudDirector | catalog", ['get']) do
    tests("#get_by_name").returns(catalog.name) { catalogs.get_by_name(catalog.name).name }
    tests("#get").returns(catalog.id) { catalogs.get(catalog.id).id }
  end
end
