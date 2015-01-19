module Fog
  module Compute
    class Vsphere
      class Real
        def list_snapshots(options = { })
          options[:folder] ||= options['folder']
          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          snapshots = []
          vm_mob_ref.snapshot.rootSnapshotList.each{|tree|
            get_snapshots(snapshots,tree)
          }
        end
      end

      def get_snapshots(snapshots,tree){
        tree.childSnapshotList.each{|sub_tree|
          snapshots.append(get_snapshots(sub_tree))
        }
      }

      class Mock
        def list_snapshots(filters = { })
        end
      end
    end
  end
end
