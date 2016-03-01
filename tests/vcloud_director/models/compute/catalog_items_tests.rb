require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests("Compute::VcloudDirector | catalog_items", ['vclouddirector', 'all']) do
  pending if Fog.mocking?

  pending if catalog.nil?
  catalog_items = catalog.catalog_items
  pending if catalog_items.empty?
  tests("#There is one or more catalog item").returns(true) { catalog_items.size >= 1 }
  catalog_item = catalog_items.first

  tests("Compute::VcloudDirector | catalog_item") do
    tests("#id").returns(String){ catalog_item.id.class }
    tests("#name").returns(String){ catalog_item.name.class }
    tests("#href").returns(String){ catalog_item.href.class }
    tests("#type").returns("application/vnd.vmware.vcloud.catalogItem+xml"){ catalog_item.type }
    tests("#vapp_template").returns(VappTemplate){ catalog_item.vapp_template.class }
  end

  tests("Compute::VcloudDirector | catalog_item", ['lazy load attrs']) do
    catalog_item.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { catalog_item.attributes[lazy_attr] }
    end
  end

  tests("Compute::VcloudDirector | catalog_item", ['load on demand']) do
    tests("#description is not loaded yet").returns(NonLoaded) { catalog_item.attributes[:description] }
    tests("#description is loaded on demand").returns(String) { catalog_item.description.class }
    tests("#description is now loaded").returns(true) { catalog_item.attributes[:description] != NonLoaded }
  end

  tests("Compute::VcloudDirector | catalog_item", ['lazy load attrs']) do
    catalog.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is now loaded").returns(true) { catalog_item.attributes[lazy_attr] != NonLoaded }
    end
  end

  tests("Compute::VcloudDirector | catalog_item", ['get']) do
    tests("#get_by_name").returns(catalog_item.name) { catalog_items.get_by_name(catalog_item.name).name }
    tests("#get").returns(catalog_item.id) { catalog_items.get(catalog_item.id).id }
  end
end
