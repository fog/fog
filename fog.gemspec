# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'
  s.platform = Gem::Platform::RUBY

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'fog'
  s.version           = '0.3.21'
  s.date              = '2010-11-17'
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

  s.files = Dir.glob("{benchs, examples, bin,lib}/**/*") + %w[
  s.add_development_dependency('rspec')
  s.add_development_dependency('shindo', '0.1.9')
    Gemfile
    Gemfile.lock
    README.rdoc
    Rakefile
    bin/fog
    fog.gemspec
    lib/fog/aws/cdn.rb
    lib/fog/aws/iam.rb
    lib/fog/aws/parsers/cdn/distribution.rb
    lib/fog/aws/parsers/cdn/get_distribution_list.rb
    lib/fog/aws/parsers/cdn/post_invalidation.rb
    lib/fog/aws/parsers/iam/basic.rb
    lib/fog/aws/parsers/iam/create_access_key.rb
    lib/fog/aws/parsers/iam/create_group.rb
    lib/fog/aws/parsers/iam/create_user.rb
    lib/fog/aws/parsers/iam/list_access_keys.rb
    lib/fog/aws/parsers/iam/list_groups.rb
    lib/fog/aws/parsers/iam/list_policies.rb
    lib/fog/aws/parsers/iam/list_users.rb
    lib/fog/aws/parsers/storage/complete_multipart_upload.rb
    lib/fog/aws/parsers/storage/initiate_multipart_upload.rb
    lib/fog/aws/parsers/storage/list_multipart_uploads.rb
    lib/fog/aws/parsers/storage/list_parts.rb
    lib/fog/aws/requests/cdn/delete_distribution.rb
    lib/fog/aws/requests/cdn/get_distribution.rb
    lib/fog/aws/requests/cdn/get_distribution_list.rb
    lib/fog/aws/requests/cdn/post_distribution.rb
    lib/fog/aws/requests/cdn/post_invalidation.rb
    lib/fog/aws/requests/cdn/put_distribution_config.rb
    lib/fog/aws/requests/iam/add_user_to_group.rb
    lib/fog/aws/requests/iam/create_access_key.rb
    lib/fog/aws/requests/iam/create_group.rb
    lib/fog/aws/requests/iam/create_user.rb
    lib/fog/aws/requests/iam/delete_access_key.rb
    lib/fog/aws/requests/iam/delete_group.rb
    lib/fog/aws/requests/iam/delete_group_policy.rb
    lib/fog/aws/requests/iam/delete_user.rb
    lib/fog/aws/requests/iam/delete_user_policy.rb
    lib/fog/aws/requests/iam/list_access_keys.rb
    lib/fog/aws/requests/iam/list_group_policies.rb
    lib/fog/aws/requests/iam/list_groups.rb
    lib/fog/aws/requests/iam/list_user_policies.rb
    lib/fog/aws/requests/iam/list_users.rb
    lib/fog/aws/requests/iam/put_group_policy.rb
    lib/fog/aws/requests/iam/put_user_policy.rb
    lib/fog/aws/requests/iam/remove_user_from_group.rb
    lib/fog/aws/requests/iam/update_access_key.rb
    lib/fog/aws/requests/storage/abort_multipart_upload.rb
    lib/fog/aws/requests/storage/complete_multipart_upload.rb
    lib/fog/aws/requests/storage/initiate_multipart_upload.rb
    lib/fog/aws/requests/storage/list_multipart_uploads.rb
    lib/fog/aws/requests/storage/list_parts.rb
    lib/fog/aws/requests/storage/upload_part.rb
    lib/fog/brightbox.rb
    lib/fog/brightbox/bin.rb
    lib/fog/brightbox/compute.rb
    lib/fog/brightbox/models/compute/account.rb
    lib/fog/brightbox/models/compute/cloud_ip.rb
    lib/fog/brightbox/models/compute/cloud_ips.rb
    lib/fog/brightbox/models/compute/flavor.rb
    lib/fog/brightbox/models/compute/flavors.rb
    lib/fog/brightbox/models/compute/image.rb
    lib/fog/brightbox/models/compute/images.rb
    lib/fog/brightbox/models/compute/server.rb
    lib/fog/brightbox/models/compute/servers.rb
    lib/fog/brightbox/models/compute/user.rb
    lib/fog/brightbox/models/compute/users.rb
    lib/fog/brightbox/models/compute/zone.rb
    lib/fog/brightbox/models/compute/zones.rb
    lib/fog/brightbox/requests/compute/create_api_client.rb
    lib/fog/brightbox/requests/compute/create_cloud_ip.rb
    lib/fog/brightbox/requests/compute/create_image.rb
    lib/fog/brightbox/requests/compute/create_server.rb
    lib/fog/brightbox/requests/compute/destroy_api_client.rb
    lib/fog/brightbox/requests/compute/destroy_cloud_ip.rb
    lib/fog/brightbox/requests/compute/destroy_image.rb
    lib/fog/brightbox/requests/compute/destroy_server.rb
    lib/fog/brightbox/requests/compute/get_account.rb
    lib/fog/brightbox/requests/compute/get_api_client.rb
    lib/fog/brightbox/requests/compute/get_cloud_ip.rb
    lib/fog/brightbox/requests/compute/get_image.rb
    lib/fog/brightbox/requests/compute/get_interface.rb
    lib/fog/brightbox/requests/compute/get_server.rb
    lib/fog/brightbox/requests/compute/get_server_type.rb
    lib/fog/brightbox/requests/compute/get_user.rb
    lib/fog/brightbox/requests/compute/get_zone.rb
    lib/fog/brightbox/requests/compute/list_api_clients.rb
    lib/fog/brightbox/requests/compute/list_cloud_ips.rb
    lib/fog/brightbox/requests/compute/list_images.rb
    lib/fog/brightbox/requests/compute/list_server_types.rb
    lib/fog/brightbox/requests/compute/list_servers.rb
    lib/fog/brightbox/requests/compute/list_users.rb
    lib/fog/brightbox/requests/compute/list_zones.rb
    lib/fog/brightbox/requests/compute/map_cloud_ip.rb
    lib/fog/brightbox/requests/compute/reset_ftp_password_account.rb
    lib/fog/brightbox/requests/compute/resize_server.rb
    lib/fog/brightbox/requests/compute/shutdown_server.rb
    lib/fog/brightbox/requests/compute/snapshot_server.rb
    lib/fog/brightbox/requests/compute/start_server.rb
    lib/fog/brightbox/requests/compute/stop_server.rb
    lib/fog/brightbox/requests/compute/unmap_cloud_ip.rb
    lib/fog/brightbox/requests/compute/update_account.rb
    lib/fog/brightbox/requests/compute/update_api_client.rb
    lib/fog/brightbox/requests/compute/update_image.rb
    lib/fog/brightbox/requests/compute/update_server.rb
    lib/fog/brightbox/requests/compute/update_user.rb
    lib/fog/core/compute.rb
    lib/fog/core/storage.rb
    lib/fog/rackspace/cdn.rb
    lib/fog/rackspace/requests/cdn/get_containers.rb
    lib/fog/rackspace/requests/cdn/head_container.rb
    lib/fog/rackspace/requests/cdn/put_container.rb
    lib/fog/vcloud/mock_data_classes.rb
    spec/core/attributes_spec.rb
    spec/vcloud/terremark/ecloud/models/server_spec.rb
    spec/vcloud/terremark/ecloud/requests/configure_vapp_spec.rb
    spec/vcloud/terremark/ecloud/requests/delete_vapp_spec.rb
    spec/vcloud/terremark/ecloud/requests/power_off_spec.rb
    tests/aws/models/compute/flavors_tests.rb
    tests/aws/models/compute/server_tests.rb
    tests/aws/models/compute/servers_tests.rb
    tests/aws/models/storage/directories_tests.rb
    tests/aws/models/storage/file_tests.rb
    tests/aws/models/storage/files_tests.rb
    tests/aws/requests/iam/access_key_tests.rb
    tests/aws/requests/iam/group_policy_tests.rb
    tests/aws/requests/iam/group_tests.rb
    tests/aws/requests/iam/user_policy_tests.rb
    tests/aws/requests/iam/user_tests.rb
    tests/aws/requests/storage/multipart_upload_tests.rb
    tests/bluebox/models/compute/flavors_tests.rb
    tests/bluebox/models/compute/server_tests.rb
    tests/bluebox/models/compute/servers_tests.rb
    tests/brightbox/helper.rb
    tests/brightbox/models/compute/flavors_tests.rb
    tests/brightbox/models/compute/server_tests.rb
    tests/brightbox/models/compute/servers_tests.rb
    tests/google/models/storage/directories_tests.rb
    tests/google/models/storage/directory_tests.rb
    tests/google/models/storage/file_tests.rb
    tests/google/models/storage/files_tests.rb
    tests/google/requests/storage/bucket_tests.rb
    tests/google/requests/storage/object_tests.rb
    tests/helpers/collection_tests.rb
    tests/helpers/compute/flavors_tests.rb
    tests/helpers/compute/server_tests.rb
    tests/helpers/compute/servers_tests.rb
    tests/helpers/model_tests.rb
    tests/helpers/storage/directories_tests.rb
    tests/helpers/storage/directory_tests.rb
    tests/helpers/storage/file_tests.rb
    tests/helpers/storage/files_tests.rb
    tests/local/models/storage/directories_tests.rb
    tests/local/models/storage/directory_tests.rb
    tests/local/models/storage/file_tests.rb
    tests/local/models/storage/files_tests.rb
    tests/rackspace/models/compute/flavors_tests.rb
    tests/rackspace/models/compute/server_tests.rb
    tests/rackspace/models/compute/servers_tests.rb
    tests/rackspace/models/storage/directories_tests.rb
    tests/rackspace/models/storage/directory_tests.rb
    tests/rackspace/models/storage/file_tests.rb
    tests/rackspace/models/storage/files_tests.rb
    tests/rackspace/requests/storage/container_tests.rb
    tests/rackspace/requests/storage/object_tests.rb
    tests/slicehost/models/compute/flavors_tests.rb
    tests/slicehost/models/compute/server_tests.rb
    tests/slicehost/models/compute/servers_tests.rb
  ]

  s.test_files = Dir.glob("{spec, tests}/**/*")
end
