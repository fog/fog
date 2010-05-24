Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'fog'
  s.version           = '0.1.5'
  s.date              = '2010-05-27'
  s.rubyforge_project = 'fog'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "brings clouds to you"
  s.description = "The Ruby cloud computing library."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["geemus (Wesley Beary)"]
  s.email    = 'geemus@gmail.com'
  s.homepage = 'http://github.com/geemus/fog'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## This sections is only necessary if you have C extensions.
  # s.require_paths << 'ext'
  # s.extensions = %w[ext/extconf.rb]

  ## If your gem includes any executables, list them here.
  s.executables = ["fog"]
  s.default_executable = 'fog'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('excon', '>=0.0.24')
  s.add_dependency('formatador', '>=0.0.10')
  s.add_dependency('json')
  s.add_dependency('mime-types')
  s.add_dependency('net-ssh')
  s.add_dependency('nokogiri')
  s.add_dependency('ruby-hmac')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('rspec')
  s.add_development_dependency('shindo')

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    README.rdoc
    Rakefile
    benchs/fog_vs.rb
    benchs/params.rb
    benchs/parse_vs_push.rb
    bin/fog
    fog.gemspec
    lib/fog.rb
    lib/fog/aws.rb
    lib/fog/aws/bin.rb
    lib/fog/aws/ec2.rb
    lib/fog/aws/elb.rb
    lib/fog/aws/models/ec2/address.rb
    lib/fog/aws/models/ec2/addresses.rb
    lib/fog/aws/models/ec2/flavor.rb
    lib/fog/aws/models/ec2/flavors.rb
    lib/fog/aws/models/ec2/image.rb
    lib/fog/aws/models/ec2/images.rb
    lib/fog/aws/models/ec2/key_pair.rb
    lib/fog/aws/models/ec2/key_pairs.rb
    lib/fog/aws/models/ec2/security_group.rb
    lib/fog/aws/models/ec2/security_groups.rb
    lib/fog/aws/models/ec2/server.rb
    lib/fog/aws/models/ec2/servers.rb
    lib/fog/aws/models/ec2/snapshot.rb
    lib/fog/aws/models/ec2/snapshots.rb
    lib/fog/aws/models/ec2/volume.rb
    lib/fog/aws/models/ec2/volumes.rb
    lib/fog/aws/models/s3/directories.rb
    lib/fog/aws/models/s3/directory.rb
    lib/fog/aws/models/s3/file.rb
    lib/fog/aws/models/s3/files.rb
    lib/fog/aws/parsers/ec2/allocate_address.rb
    lib/fog/aws/parsers/ec2/attach_volume.rb
    lib/fog/aws/parsers/ec2/basic.rb
    lib/fog/aws/parsers/ec2/create_key_pair.rb
    lib/fog/aws/parsers/ec2/create_snapshot.rb
    lib/fog/aws/parsers/ec2/create_volume.rb
    lib/fog/aws/parsers/ec2/describe_addresses.rb
    lib/fog/aws/parsers/ec2/describe_availability_zones.rb
    lib/fog/aws/parsers/ec2/describe_images.rb
    lib/fog/aws/parsers/ec2/describe_instances.rb
    lib/fog/aws/parsers/ec2/describe_key_pairs.rb
    lib/fog/aws/parsers/ec2/describe_regions.rb
    lib/fog/aws/parsers/ec2/describe_reserved_instances.rb
    lib/fog/aws/parsers/ec2/describe_security_groups.rb
    lib/fog/aws/parsers/ec2/describe_snapshots.rb
    lib/fog/aws/parsers/ec2/describe_volumes.rb
    lib/fog/aws/parsers/ec2/detach_volume.rb
    lib/fog/aws/parsers/ec2/get_console_output.rb
    lib/fog/aws/parsers/ec2/run_instances.rb
    lib/fog/aws/parsers/ec2/terminate_instances.rb
    lib/fog/aws/parsers/elb/create_load_balancer.rb
    lib/fog/aws/parsers/elb/delete_load_balancer.rb
    lib/fog/aws/parsers/elb/deregister_instances_from_load_balancer.rb
    lib/fog/aws/parsers/elb/describe_instance_health.rb
    lib/fog/aws/parsers/elb/describe_load_balancers.rb
    lib/fog/aws/parsers/elb/disable_availability_zones_for_load_balancer.rb
    lib/fog/aws/parsers/elb/enable_availability_zones_for_load_balancer.rb
    lib/fog/aws/parsers/elb/register_instances_with_load_balancer.rb
    lib/fog/aws/parsers/s3/access_control_list.rb
    lib/fog/aws/parsers/s3/copy_object.rb
    lib/fog/aws/parsers/s3/get_bucket.rb
    lib/fog/aws/parsers/s3/get_bucket_location.rb
    lib/fog/aws/parsers/s3/get_bucket_logging.rb
    lib/fog/aws/parsers/s3/get_bucket_object_versions.rb
    lib/fog/aws/parsers/s3/get_bucket_versioning.rb
    lib/fog/aws/parsers/s3/get_request_payment.rb
    lib/fog/aws/parsers/s3/get_service.rb
    lib/fog/aws/parsers/simpledb/basic.rb
    lib/fog/aws/parsers/simpledb/domain_metadata.rb
    lib/fog/aws/parsers/simpledb/get_attributes.rb
    lib/fog/aws/parsers/simpledb/list_domains.rb
    lib/fog/aws/parsers/simpledb/select.rb
    lib/fog/aws/requests/ec2/allocate_address.rb
    lib/fog/aws/requests/ec2/associate_address.rb
    lib/fog/aws/requests/ec2/attach_volume.rb
    lib/fog/aws/requests/ec2/authorize_security_group_ingress.rb
    lib/fog/aws/requests/ec2/create_key_pair.rb
    lib/fog/aws/requests/ec2/create_security_group.rb
    lib/fog/aws/requests/ec2/create_snapshot.rb
    lib/fog/aws/requests/ec2/create_volume.rb
    lib/fog/aws/requests/ec2/delete_key_pair.rb
    lib/fog/aws/requests/ec2/delete_security_group.rb
    lib/fog/aws/requests/ec2/delete_snapshot.rb
    lib/fog/aws/requests/ec2/delete_volume.rb
    lib/fog/aws/requests/ec2/describe_addresses.rb
    lib/fog/aws/requests/ec2/describe_availability_zones.rb
    lib/fog/aws/requests/ec2/describe_images.rb
    lib/fog/aws/requests/ec2/describe_instances.rb
    lib/fog/aws/requests/ec2/describe_key_pairs.rb
    lib/fog/aws/requests/ec2/describe_regions.rb
    lib/fog/aws/requests/ec2/describe_reserved_instances.rb
    lib/fog/aws/requests/ec2/describe_security_groups.rb
    lib/fog/aws/requests/ec2/describe_snapshots.rb
    lib/fog/aws/requests/ec2/describe_volumes.rb
    lib/fog/aws/requests/ec2/detach_volume.rb
    lib/fog/aws/requests/ec2/disassociate_address.rb
    lib/fog/aws/requests/ec2/get_console_output.rb
    lib/fog/aws/requests/ec2/modify_image_attributes.rb
    lib/fog/aws/requests/ec2/reboot_instances.rb
    lib/fog/aws/requests/ec2/release_address.rb
    lib/fog/aws/requests/ec2/revoke_security_group_ingress.rb
    lib/fog/aws/requests/ec2/run_instances.rb
    lib/fog/aws/requests/ec2/terminate_instances.rb
    lib/fog/aws/requests/elb/create_load_balancer.rb
    lib/fog/aws/requests/elb/delete_load_balancer.rb
    lib/fog/aws/requests/elb/deregister_instances_from_load_balancer.rb
    lib/fog/aws/requests/elb/describe_instance_health.rb
    lib/fog/aws/requests/elb/describe_load_balancers.rb
    lib/fog/aws/requests/elb/disable_availability_zones_for_load_balancer.rb
    lib/fog/aws/requests/elb/enable_availability_zones_for_load_balancer.rb
    lib/fog/aws/requests/elb/register_instances_with_load_balancer.rb
    lib/fog/aws/requests/s3/copy_object.rb
    lib/fog/aws/requests/s3/delete_bucket.rb
    lib/fog/aws/requests/s3/delete_object.rb
    lib/fog/aws/requests/s3/get_bucket.rb
    lib/fog/aws/requests/s3/get_bucket_acl.rb
    lib/fog/aws/requests/s3/get_bucket_location.rb
    lib/fog/aws/requests/s3/get_bucket_logging.rb
    lib/fog/aws/requests/s3/get_bucket_object_versions.rb
    lib/fog/aws/requests/s3/get_bucket_versioning.rb
    lib/fog/aws/requests/s3/get_object.rb
    lib/fog/aws/requests/s3/get_object_acl.rb
    lib/fog/aws/requests/s3/get_object_torrent.rb
    lib/fog/aws/requests/s3/get_object_url.rb
    lib/fog/aws/requests/s3/get_request_payment.rb
    lib/fog/aws/requests/s3/get_service.rb
    lib/fog/aws/requests/s3/head_object.rb
    lib/fog/aws/requests/s3/put_bucket.rb
    lib/fog/aws/requests/s3/put_bucket_acl.rb
    lib/fog/aws/requests/s3/put_bucket_logging.rb
    lib/fog/aws/requests/s3/put_bucket_versioning.rb
    lib/fog/aws/requests/s3/put_object.rb
    lib/fog/aws/requests/s3/put_request_payment.rb
    lib/fog/aws/requests/simpledb/batch_put_attributes.rb
    lib/fog/aws/requests/simpledb/create_domain.rb
    lib/fog/aws/requests/simpledb/delete_attributes.rb
    lib/fog/aws/requests/simpledb/delete_domain.rb
    lib/fog/aws/requests/simpledb/domain_metadata.rb
    lib/fog/aws/requests/simpledb/get_attributes.rb
    lib/fog/aws/requests/simpledb/list_domains.rb
    lib/fog/aws/requests/simpledb/put_attributes.rb
    lib/fog/aws/requests/simpledb/select.rb
    lib/fog/aws/s3.rb
    lib/fog/aws/simpledb.rb
    lib/fog/bin.rb
    lib/fog/bluebox.rb
    lib/fog/bluebox/bin.rb
    lib/fog/bluebox/models/flavor.rb
    lib/fog/bluebox/models/flavors.rb
    lib/fog/bluebox/models/image.rb
    lib/fog/bluebox/models/images.rb
    lib/fog/bluebox/models/server.rb
    lib/fog/bluebox/models/servers.rb
    lib/fog/bluebox/parsers/create_block.rb
    lib/fog/bluebox/parsers/get_block.rb
    lib/fog/bluebox/parsers/get_blocks.rb
    lib/fog/bluebox/parsers/get_flavor.rb
    lib/fog/bluebox/parsers/get_flavors.rb
    lib/fog/bluebox/parsers/get_images.rb
    lib/fog/bluebox/requests/create_block.rb
    lib/fog/bluebox/requests/destroy_block.rb
    lib/fog/bluebox/requests/get_block.rb
    lib/fog/bluebox/requests/get_blocks.rb
    lib/fog/bluebox/requests/get_flavor.rb
    lib/fog/bluebox/requests/get_flavors.rb
    lib/fog/bluebox/requests/get_images.rb
    lib/fog/collection.rb
    lib/fog/connection.rb
    lib/fog/credentials.rb
    lib/fog/deprecation.rb
    lib/fog/local.rb
    lib/fog/local/bin.rb
    lib/fog/local/models/directories.rb
    lib/fog/local/models/directory.rb
    lib/fog/local/models/file.rb
    lib/fog/local/models/files.rb
    lib/fog/model.rb
    lib/fog/parser.rb
    lib/fog/rackspace.rb
    lib/fog/rackspace/bin.rb
    lib/fog/rackspace/files.rb
    lib/fog/rackspace/models/files/directories.rb
    lib/fog/rackspace/models/files/directory.rb
    lib/fog/rackspace/models/files/file.rb
    lib/fog/rackspace/models/files/files.rb
    lib/fog/rackspace/models/servers/flavor.rb
    lib/fog/rackspace/models/servers/flavors.rb
    lib/fog/rackspace/models/servers/image.rb
    lib/fog/rackspace/models/servers/images.rb
    lib/fog/rackspace/models/servers/server.rb
    lib/fog/rackspace/models/servers/servers.rb
    lib/fog/rackspace/requests/files/delete_container.rb
    lib/fog/rackspace/requests/files/delete_object.rb
    lib/fog/rackspace/requests/files/get_container.rb
    lib/fog/rackspace/requests/files/get_containers.rb
    lib/fog/rackspace/requests/files/get_object.rb
    lib/fog/rackspace/requests/files/head_container.rb
    lib/fog/rackspace/requests/files/head_containers.rb
    lib/fog/rackspace/requests/files/head_object.rb
    lib/fog/rackspace/requests/files/put_container.rb
    lib/fog/rackspace/requests/files/put_object.rb
    lib/fog/rackspace/requests/servers/create_image.rb
    lib/fog/rackspace/requests/servers/create_server.rb
    lib/fog/rackspace/requests/servers/delete_image.rb
    lib/fog/rackspace/requests/servers/delete_server.rb
    lib/fog/rackspace/requests/servers/get_flavor_details.rb
    lib/fog/rackspace/requests/servers/get_image_details.rb
    lib/fog/rackspace/requests/servers/get_server_details.rb
    lib/fog/rackspace/requests/servers/list_addresses.rb
    lib/fog/rackspace/requests/servers/list_flavors.rb
    lib/fog/rackspace/requests/servers/list_flavors_detail.rb
    lib/fog/rackspace/requests/servers/list_images.rb
    lib/fog/rackspace/requests/servers/list_images_detail.rb
    lib/fog/rackspace/requests/servers/list_private_addresses.rb
    lib/fog/rackspace/requests/servers/list_public_addresses.rb
    lib/fog/rackspace/requests/servers/list_servers.rb
    lib/fog/rackspace/requests/servers/list_servers_detail.rb
    lib/fog/rackspace/requests/servers/reboot_server.rb
    lib/fog/rackspace/requests/servers/update_server.rb
    lib/fog/rackspace/servers.rb
    lib/fog/slicehost.rb
    lib/fog/slicehost/bin.rb
    lib/fog/slicehost/models/flavor.rb
    lib/fog/slicehost/models/flavors.rb
    lib/fog/slicehost/models/image.rb
    lib/fog/slicehost/models/images.rb
    lib/fog/slicehost/models/server.rb
    lib/fog/slicehost/models/servers.rb
    lib/fog/slicehost/parsers/create_slice.rb
    lib/fog/slicehost/parsers/get_backups.rb
    lib/fog/slicehost/parsers/get_flavor.rb
    lib/fog/slicehost/parsers/get_flavors.rb
    lib/fog/slicehost/parsers/get_image.rb
    lib/fog/slicehost/parsers/get_images.rb
    lib/fog/slicehost/parsers/get_slice.rb
    lib/fog/slicehost/parsers/get_slices.rb
    lib/fog/slicehost/requests/create_slice.rb
    lib/fog/slicehost/requests/delete_slice.rb
    lib/fog/slicehost/requests/get_backups.rb
    lib/fog/slicehost/requests/get_flavor.rb
    lib/fog/slicehost/requests/get_flavors.rb
    lib/fog/slicehost/requests/get_image.rb
    lib/fog/slicehost/requests/get_images.rb
    lib/fog/slicehost/requests/get_slice.rb
    lib/fog/slicehost/requests/get_slices.rb
    lib/fog/slicehost/requests/reboot_slice.rb
    lib/fog/ssh.rb
    lib/fog/terremark.rb
    lib/fog/terremark/bin.rb
    lib/fog/terremark/ecloud.rb
    lib/fog/terremark/models/shared/address.rb
    lib/fog/terremark/models/shared/addresses.rb
    lib/fog/terremark/models/shared/network.rb
    lib/fog/terremark/models/shared/networks.rb
    lib/fog/terremark/models/shared/server.rb
    lib/fog/terremark/models/shared/servers.rb
    lib/fog/terremark/models/shared/task.rb
    lib/fog/terremark/models/shared/tasks.rb
    lib/fog/terremark/models/shared/vdc.rb
    lib/fog/terremark/models/shared/vdcs.rb
    lib/fog/terremark/parser.rb
    lib/fog/terremark/parsers/shared/get_catalog.rb
    lib/fog/terremark/parsers/shared/get_catalog_item.rb
    lib/fog/terremark/parsers/shared/get_internet_services.rb
    lib/fog/terremark/parsers/shared/get_network_ips.rb
    lib/fog/terremark/parsers/shared/get_node_services.rb
    lib/fog/terremark/parsers/shared/get_organization.rb
    lib/fog/terremark/parsers/shared/get_organizations.rb
    lib/fog/terremark/parsers/shared/get_public_ips.rb
    lib/fog/terremark/parsers/shared/get_tasks_list.rb
    lib/fog/terremark/parsers/shared/get_vapp_template.rb
    lib/fog/terremark/parsers/shared/get_vdc.rb
    lib/fog/terremark/parsers/shared/instantiate_vapp_template.rb
    lib/fog/terremark/parsers/shared/internet_service.rb
    lib/fog/terremark/parsers/shared/network.rb
    lib/fog/terremark/parsers/shared/node_service.rb
    lib/fog/terremark/parsers/shared/public_ip.rb
    lib/fog/terremark/parsers/shared/task.rb
    lib/fog/terremark/parsers/shared/vapp.rb
    lib/fog/terremark/requests/shared/add_internet_service.rb
    lib/fog/terremark/requests/shared/add_node_service.rb
    lib/fog/terremark/requests/shared/create_internet_service.rb
    lib/fog/terremark/requests/shared/delete_internet_service.rb
    lib/fog/terremark/requests/shared/delete_node_service.rb
    lib/fog/terremark/requests/shared/delete_public_ip.rb
    lib/fog/terremark/requests/shared/delete_vapp.rb
    lib/fog/terremark/requests/shared/deploy_vapp.rb
    lib/fog/terremark/requests/shared/get_catalog.rb
    lib/fog/terremark/requests/shared/get_catalog_item.rb
    lib/fog/terremark/requests/shared/get_internet_services.rb
    lib/fog/terremark/requests/shared/get_network.rb
    lib/fog/terremark/requests/shared/get_network_ips.rb
    lib/fog/terremark/requests/shared/get_node_services.rb
    lib/fog/terremark/requests/shared/get_organization.rb
    lib/fog/terremark/requests/shared/get_organizations.rb
    lib/fog/terremark/requests/shared/get_public_ip.rb
    lib/fog/terremark/requests/shared/get_public_ips.rb
    lib/fog/terremark/requests/shared/get_task.rb
    lib/fog/terremark/requests/shared/get_tasks_list.rb
    lib/fog/terremark/requests/shared/get_vapp.rb
    lib/fog/terremark/requests/shared/get_vapp_template.rb
    lib/fog/terremark/requests/shared/get_vdc.rb
    lib/fog/terremark/requests/shared/instantiate_vapp_template.rb
    lib/fog/terremark/requests/shared/power_off.rb
    lib/fog/terremark/requests/shared/power_on.rb
    lib/fog/terremark/requests/shared/power_reset.rb
    lib/fog/terremark/requests/shared/power_shutdown.rb
    lib/fog/terremark/shared.rb
    lib/fog/terremark/vcloud.rb
    lib/fog/vcloud.rb
    lib/fog/vcloud/bin.rb
    lib/fog/vcloud/collection.rb
    lib/fog/vcloud/model.rb
    lib/fog/vcloud/models/vdc.rb
    lib/fog/vcloud/models/vdcs.rb
    lib/fog/vcloud/parser.rb
    lib/fog/vcloud/parsers/get_organization.rb
    lib/fog/vcloud/parsers/get_vdc.rb
    lib/fog/vcloud/parsers/get_versions.rb
    lib/fog/vcloud/parsers/login.rb
    lib/fog/vcloud/requests/get_organization.rb
    lib/fog/vcloud/requests/get_vdc.rb
    lib/fog/vcloud/requests/get_versions.rb
    lib/fog/vcloud/requests/login.rb
    lib/fog/vcloud/terremark/all.rb
    lib/fog/vcloud/terremark/ecloud.rb
    lib/fog/vcloud/terremark/ecloud/models/vdc.rb
    lib/fog/vcloud/terremark/ecloud/models/vdcs.rb
    lib/fog/vcloud/terremark/ecloud/parsers/get_vdc.rb
    lib/fog/vcloud/terremark/ecloud/requests/get_vdc.rb
    lib/fog/vcloud/terremark/ecloud/requests/login.rb
    lib/fog/vcloud/terremark/vcloud.rb
    lib/fog/vcloud/terremark/vcloud/parsers/get_vdc.rb
    lib/fog/vcloud/terremark/vcloud/requests/get_vdc.rb
    spec/aws/models/ec2/address_spec.rb
    spec/aws/models/ec2/addresses_spec.rb
    spec/aws/models/ec2/flavors_spec.rb
    spec/aws/models/ec2/key_pair_spec.rb
    spec/aws/models/ec2/key_pairs_spec.rb
    spec/aws/models/ec2/security_group_spec.rb
    spec/aws/models/ec2/security_groups_spec.rb
    spec/aws/models/ec2/server_spec.rb
    spec/aws/models/ec2/servers_spec.rb
    spec/aws/models/ec2/snapshot_spec.rb
    spec/aws/models/ec2/snapshots_spec.rb
    spec/aws/models/ec2/volume_spec.rb
    spec/aws/models/ec2/volumes_spec.rb
    spec/aws/models/s3/directories_spec.rb
    spec/aws/models/s3/directory_spec.rb
    spec/aws/models/s3/file_spec.rb
    spec/aws/models/s3/files_spec.rb
    spec/aws/requests/ec2/describe_images_spec.rb
    spec/aws/requests/s3/copy_object_spec.rb
    spec/aws/requests/s3/delete_bucket_spec.rb
    spec/aws/requests/s3/delete_object_spec.rb
    spec/aws/requests/s3/get_bucket_location_spec.rb
    spec/aws/requests/s3/get_bucket_spec.rb
    spec/aws/requests/s3/get_object_spec.rb
    spec/aws/requests/s3/get_request_payment_spec.rb
    spec/aws/requests/s3/get_service_spec.rb
    spec/aws/requests/s3/head_object_spec.rb
    spec/aws/requests/s3/put_bucket_spec.rb
    spec/aws/requests/s3/put_object_spec.rb
    spec/aws/requests/s3/put_request_payment_spec.rb
    spec/aws/requests/simpledb/batch_put_attributes_spec.rb
    spec/aws/requests/simpledb/create_domain_spec.rb
    spec/aws/requests/simpledb/delete_attributes_spec.rb
    spec/aws/requests/simpledb/delete_domain_spec.rb
    spec/aws/requests/simpledb/domain_metadata_spec.rb
    spec/aws/requests/simpledb/get_attributes_spec.rb
    spec/aws/requests/simpledb/list_domains_spec.rb
    spec/aws/requests/simpledb/put_attributes_spec.rb
    spec/aws/requests/simpledb/select_spec.rb
    spec/bluebox/models/flavors_spec.rb
    spec/bluebox/models/server_spec.rb
    spec/bluebox/models/servers_spec.rb
    spec/compact_progress_bar_formatter.rb
    spec/lorem.txt
    spec/rackspace/models/servers/flavors_spec.rb
    spec/rackspace/models/servers/server_spec.rb
    spec/rackspace/models/servers/servers_spec.rb
    spec/rackspace/requests/files/delete_container_spec.rb
    spec/rackspace/requests/files/delete_object_spec.rb
    spec/rackspace/requests/files/get_container_spec.rb
    spec/rackspace/requests/files/get_containers_spec.rb
    spec/rackspace/requests/files/get_object_spec.rb
    spec/rackspace/requests/files/head_container_spec.rb
    spec/rackspace/requests/files/head_containers_spec.rb
    spec/rackspace/requests/files/head_object_spec.rb
    spec/rackspace/requests/files/put_container_spec.rb
    spec/rackspace/requests/files/put_object_spec.rb
    spec/shared_examples/flavors_examples.rb
    spec/shared_examples/server_examples.rb
    spec/shared_examples/servers_examples.rb
    spec/slicehost/models/flavors_spec.rb
    spec/slicehost/models/server_spec.rb
    spec/slicehost/models/servers_spec.rb
    spec/spec_helper.rb
    spec/vcloud/bin_spec.rb
    spec/vcloud/models/vdc_spec.rb
    spec/vcloud/models/vdcs_spec.rb
    spec/vcloud/requests/get_organization_spec.rb
    spec/vcloud/requests/get_vdc_spec.rb
    spec/vcloud/requests/get_versions_spec.rb
    spec/vcloud/requests/login_spec.rb
    spec/vcloud/spec_helper.rb
    spec/vcloud/terremark/ecloud/models/vdc_spec.rb
    spec/vcloud/terremark/ecloud/models/vdcs_spec.rb
    spec/vcloud/terremark/ecloud/requests/get_vdc_spec.rb
    spec/vcloud/terremark/ecloud/requests/login_spec.rb
    spec/vcloud/terremark/vcloud/requests/get_vdc_spec.rb
    spec/vcloud/vcloud_spec.rb
    tests/aws/helper.rb
    tests/aws/requests/ec2/address_tests.rb
    tests/aws/requests/ec2/availability_zone_tests.rb
    tests/aws/requests/ec2/instance_tests.rb
    tests/aws/requests/ec2/key_pair_tests.rb
    tests/aws/requests/ec2/region_tests.rb
    tests/aws/requests/ec2/security_group_tests.rb
    tests/aws/requests/ec2/snapshot_tests.rb
    tests/aws/requests/ec2/volume_tests.rb
    tests/helper.rb
    tests/helper_tests.rb
    tests/rackspace/helper.rb
    tests/rackspace/requests/servers/create_image_tests.rb
    tests/rackspace/requests/servers/create_server_tests.rb
    tests/rackspace/requests/servers/delete_image_tests.rb
    tests/rackspace/requests/servers/delete_server_tests.rb
    tests/rackspace/requests/servers/get_flavor_details_tests.rb
    tests/rackspace/requests/servers/get_image_details_tests.rb
    tests/rackspace/requests/servers/get_server_details_tests.rb
    tests/rackspace/requests/servers/list_addresses_tests.rb
    tests/rackspace/requests/servers/list_flavors_detail_tests.rb
    tests/rackspace/requests/servers/list_flavors_tests.rb
    tests/rackspace/requests/servers/list_images_detail_tests.rb
    tests/rackspace/requests/servers/list_images_tests.rb
    tests/rackspace/requests/servers/list_private_addresses_tests.rb
    tests/rackspace/requests/servers/list_public_addresses_tests.rb
    tests/rackspace/requests/servers/list_servers_detail_tests.rb
    tests/rackspace/requests/servers/list_servers_tests.rb
    tests/rackspace/requests/servers/reboot_server_tests.rb
    tests/rackspace/requests/servers/update_server_tests.rb
    tests/slicehost/helper.rb
    tests/slicehost/requests/create_slice_tests.rb
    tests/slicehost/requests/delete_slice_tests.rb
    tests/slicehost/requests/get_backups_tests.rb
    tests/slicehost/requests/get_flavor_tests.rb
    tests/slicehost/requests/get_flavors_tests.rb
    tests/slicehost/requests/get_image_tests.rb
    tests/slicehost/requests/get_images_tests.rb
    tests/slicehost/requests/get_slice_tests.rb
    tests/slicehost/requests/get_slices_tests.rb
    tests/slicehost/requests/reboot_slice_tests.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^[spec|tests]\/.*_[spec|tests]\.rb/ }
end
