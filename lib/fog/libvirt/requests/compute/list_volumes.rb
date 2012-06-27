module Fog
  module Compute
    class Libvirt
      class Real
        def list_volumes(filter = { })
          data = []
          if filter.keys.empty?
            raw_volumes do |pool|
              pool.list_volumes.each do |volume_name|
                data << volume_to_attributes(pool.lookup_volume_by_name(volume_name))
              end
            end
          else
            return [get_volume(filter)]
          end
          data.compact
        end

        private

        def volume_to_attributes(vol)

          format_type = xml_element(vol.xml_desc, "/volume/target/format", "type") rescue nil # not all volumes have types, e.g. LVM
          return nil if format_type == "dir"

          {
            :pool_name   => vol.pool.name,
            :key         => vol.key,
            :id          => vol.key,
            :path        => vol.path,
            :name        => vol.name,
            :format_type => format_type,
            :allocation  => bytes_to_gb(vol.info.allocation),
            :capacity    => bytes_to_gb(vol.info.capacity),
          }
        end

        def bytes_to_gb bytes
          bytes / 1024**3
        end

        def raw_volumes
          client.list_storage_pools.each do |pool_name|
            pool = client.lookup_storage_pool_by_name(pool_name)
            yield(pool)
          end
        end

        def get_volume filter = { }, raw = false
          raw_volumes do |pool|
            vol = case filter.keys.first
                    when :name
                      pool.lookup_volume_by_name(filter[:name]) rescue nil
                    when :key
                      pool.lookup_volume_by_key(filter[:key]) rescue nil
                    when :path
                      pool.lookup_volume_by_path(filter[:path]) rescue nil
                  end
            if vol
              return raw ? vol : volume_to_attributes(vol)
            end
          end
          { }
        end
      end

      class Mock
        def list_volumes(filters={ })
          vol1 = mock_volume 'vol1'
          vol2 = mock_volume 'vol2'
          [vol1, vol2]
        end

        def mock_volume name
          {
              :pool_name   => 'vol.pool.name',
              :key         => 'vol.key',
              :id          => 'vol.key',
              :path        => 'vol.path',
              :name        => name,
              :format_type => 'raw',
              :allocation  => 123,
              :capacity    => 123,
          }
        end
      end
    end
  end
end
