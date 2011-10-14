module Fog
  module Compute
    class Clodo
      class Real
        # Вход:
        # name - название VPS
        # vps_title - название VPS (может использоваться либо этот параметр, либо "name")
        # vps_type - тип VPS (VirtualServer,ScaleServer)
        # vps_memory - память (для ScaleServer - нижняя граница) (в MB)
        # vps_memory_max - верхняя граница памяти для ScaleServer (в MB)
        # vps_hdd - размер диска (в GB)
        # vps_admin - тип поддержки (1 - обычная, 2 - расширенная, 3 - VIP)
        # vps_os - id ОС
        # Выход:
        # id - номер VPS
        # name - название VPS
        # imageId - id ОС
        # adminPass - пароль root

        def create_server(image_id, options = {})
          data = {
            'server' => {
              :vps_os   => image_id,
              :vps_hdd => options[:vps_hdd]?options[:vps_hdd]:5,
              :vps_memory => options[:vps_memory]?options[:vps_memory]:256,
              :vps_memory_max => options[:vps_memory_max]?options[:vps_memory_max]:1024,
              :vps_admin => options[:vps_admin]?options[:vps_admin]:1
            }
          }

          data['server'].merge! options if options

          request(
                  :body     => MultiJson.encode(data),
                  :expects  => [200, 202],
                  :method   => 'POST',
                  :path     => 'servers'
                  )

        end
        class Mock
          def create_server(image_id, options = {})
            response = Excon::response.new
            response.status = 202

            data = {
              'id'        => Fog::Mock.random_numbers(6).to_i,
              'imageId'   => image_id,
              'name'      => options['name'] || "server_#{rand(999)}",
              'adminPass'    => '23ryh8udbcbyt'
            }

            self.data[:last_modified][:servers][data['id']] = Time.now
            self.data[:servers][data['id']] = data
            response.body = { 'server' => data.merge({'adminPass' => 'password'}) }
            response
          end
        end
      end
    end
  end
end
