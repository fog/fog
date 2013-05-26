module Fog
  module Volume
    class OpenStack
      
      class Real
        def list_extensions(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'extensions',
            :query   => filters
          )
        end
      end

      class Mock
        def list_extensions(filters = {})
          Excon::Response.new(
            :status => 200,
            :body => {
              'extensions' => [
                { 
                  'updated' => '2012-08-25T00:00:00+00:00', 
                  'name' => 'AdminActions', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/admin-actions/api/v1.1', 
                  'alias' => 'os-admin-actions', 
                  'description' => 'Enable admin actions.'
                }, 
                { 
                  'updated' => '2012-12-12T00:00:00+00:00', 
                  'name' => 'Backups', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/backups/api/v1', 
                  'alias' => 'backups', 
                  'description' => 'Backups support.'
                },
                { 
                  'updated' => '2012-08-13T00:00:00+00:00', 
                  'name' => 'CreateVolumeExtension', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/image-create/api/v1', 
                  'alias' => 'os-image-create', 
                  'description' => 'Allow creating a volume from an image in the Create Volume v1 API'
                },                
                { 
                  'updated' => '2012-06-19T00:00:00+00:00', 
                  'name' => 'ExtendedSnapshotAttributes', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/extended_snapshot_attributes/api/v1', 
                  'alias' => 'os-extended-snapshot-attributes', 
                  'description' => 'Extended SnapshotAttributes support.'
                },                
                { 
                  'updated' => '2011-06-29T00:00:00+00:00', 
                  'name' => 'Hosts', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/hosts/api/v1.1', 
                  'alias' => 'os-hosts', 
                  'description' => 'Admin-only host administration'
                },                 
                { 
                  'updated' => '2012-03-12T00:00:00+00:00', 
                  'name' => 'QuotaClasses', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/quota-classes-sets/api/v1.1', 
                  'alias' => 'os-quota-class-sets', 
                  'description' => 'Quota classes management support'
                },                 
                { 
                  'updated' => '2011-08-08T00:00:00+00:00', 
                  'name' => 'Quotas', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/compute/ext/quotas-sets/api/v1.1', 
                  'alias' => 'os-quota-sets', 
                  'description' => 'Quotas management support'
                },
                { 
                  'updated' => '2012-10-28T00:00:00-00:00', 
                  'name' => 'Services', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/services/api/v2', 
                  'alias' => 'os-services', 
                  'description' => 'Services support'
                },                
                { 
                  'updated' => '2011-08-24T00:00:00+00:00', 
                  'name' => 'TypesExtraSpecs', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/types-extra-specs/api/v1', 
                  'alias' => 'os-types-extra-specs',
                  'description' => 'Types extra specs support'
                },                 
                { 
                  'updated' => '2011-08-24T00:00:00+00:00', 
                  'name' => 'TypesManage', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/types-manage/api/v1', 
                  'alias' => 'os-types-manage', 
                  'description' => 'Types manage support.'
                },
                { 
                  'updated' => '2012-05-31T00:00:00+00:00', 
                  'name' => 'VolumeActions', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/volume-actions/api/v1.1', 
                  'alias' => 'os-volume-actions', 
                  'description' => 'Enable volume actions'
                },                
                { 
                  'updated' => '2011-11-03T00:00:00+00:00', 
                  'name' => 'VolumeHostAttribute', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/volume_host_attribute/api/v1', 
                  'alias' => 'os-vol-host-attr', 
                  'description' => 'Expose host as an attribute of a volume.'
                },                
                { 
                  'updated' => '2012-12-07T00:00:00+00:00', 
                  'name' => 'VolumeImageMetadata', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/volume_image_metadata/api/v1', 
                  'alias' => 'os-vol-image-meta', 
                  'description' => 'Show image metadata associated with the volume'
                },                                
                { 
                  'updated' => '2011-11-03T00:00:00+00:00', 
                  'name' => 'VolumeTenantAttribute', 
                  'links' => [], 
                  'namespace' => 'http://docs.openstack.org/volume/ext/volume_tenant_attribute/api/v1', 
                  'alias' => 'os-vol-tenant-attr', 
                  'description' => 'Expose the internal project_id as an attribute of a volume.'
                }, 
              ]
            }
          )
        end
      end          
        
    end
  end
end