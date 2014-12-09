class OpenStack
  module Compute
    module Formats
      SUMMARY = {
        'id'    => String,
        'name'  => String,
        'links'  => Array
      }
    end
  end
end

def compute
  Fog::Compute[:openstack]
end

def get_flavor_ref
  ENV['OPENSTACK_FLAVOR_REF'] || compute.list_flavors.body['flavors'].first['id']
end

def get_image_ref
  ENV['OPENSTACK_IMAGE_REF'] || compute.list_images.body['images'].first['id']
end

def get_volume_ref
  ENV['OPENSTACK_VOLUME_REF'] || compute.list_volumes.body['volumes'].first['id']
end

def get_flavor_ref_resize
  # by default we simply add one to the default flavor ref
  ENV['OPENSTACK_FLAVOR_REF_RESIZE'] || (get_flavor_ref.to_i + 1).to_s
end

def set_password_enabled
  pw_enabled = ENV['OPENSTACK_SET_PASSWORD_ENABLED'] || "true"
  return pw_enabled == "true"
end

def get_security_group_ref
  ENV['OPENSTACK_SECURITY_GROUP_REF'] || compute.list_security_groups.body['security_groups'].first['name']
end
