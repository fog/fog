module Fog
  module Compute
    class Vsphere
      class Real
        def list_snapshots(options = { })
          options[:folder] ||= options['folder']
          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          snapshots = []
          if vm_mob_ref.snapshot
            vm_mob_ref.snapshot.rootSnapshotList.each{|tree|
              get_snapshots(snapshots,tree)
            }
          end
          snapshots
        end

      private
        def get_snapshots(snapshots,tree)
          snapshots.append({'createTime'=>tree.createTime,
                            'id'=>tree.id,
                            'name'=>tree.name,
                            'description'=>tree.description,
                            'snapshot'=>tree.snapshot
                            })
          tree.childSnapshotList.each{|sub_tree|
            get_snapshots(snapshots,sub_tree)
          }
        end
      end

      class Mock
        def list_snapshots(filters = { })
        end
      end
    end
  end
end
