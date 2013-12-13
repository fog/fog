require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests('Compute::VcloudDirector | media', ['vclouddirector']) do
  pending if Fog.mocking?

  medias = vdc.medias
  media_name = VcloudDirector::Compute::Helper.test_name

  tests('Compute::VcloudDirector | media', ['create']) do
    tests('#create').returns(Fog::Compute::VcloudDirector::Media) do
      File.open(VcloudDirector::Compute::Helper.fixture('test.iso'), 'rb') do |iso|
        medias.create(media_name, iso).class
      end
    end
  end

  media = medias.get_by_name(media_name)

  tests('Compute::VcloudDirector | media') do
    tests('#href').returns(String) { media.href.class }
    tests('#type').returns('application/vnd.vmware.vcloud.media+xml') { media.type }
    tests('#id').returns(String) { media.id.class }
    tests('#name').returns(String) { media.name.class }
  end

  tests('Compute::VcloudDirector | media', ['lazy load attrs']) do
    media.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is not loaded yet").returns(NonLoaded) { media.attributes[lazy_attr] }
    end
  end

  tests('Compute::VcloudDirector | media', ['load on demand']) do
    tests('#description is not loaded yet').returns(NonLoaded) { media.attributes[:description] }
    tests('#description is loaded on demand').returns(String) { media.description.class }
    tests('#description is now loaded').returns(true) { media.attributes[:description] != NonLoaded }
  end

  tests('Compute::VcloudDirector | media', ['lazy load attrs']) do
    media.lazy_load_attrs.each do |lazy_attr|
      tests("##{lazy_attr} is now loaded").returns(true) { media.attributes[lazy_attr] != NonLoaded }
    end
  end

  tests('Compute::VcloudDirector | media' ['attributes']) do
    tests('#status').returns(Fixnum) { media.status.class }
    tests('#image_type').returns(String) { media.image_type.class }
    tests('#size').returns(Fixnum) { media.size.class }
  end

  tests('Compute::VcloudDirector | media', ['get']) do
    tests('#get_by_name').returns(media.name) { medias.get_by_name(media.name).name }
    tests('#get').returns(media.id) { medias.get(media.id).id }
  end

  tests('Compute::VcloudDirector | media', ['destroy']) do
    tests('#destroy').returns(true) { media.destroy }
  end
end
