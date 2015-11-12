module Fog
  module Compute
    class Fogdocker
      class Real
        def image_search(query = {})
          Docker::Util.parse_json(@connection.get('/images/search', query)).map do |image|
            downcase_hash_keys(image)
          end
        end
      end
      class Mock
        def image_search(query = {})
          [
              {"description" => "",
               "is_official" => false,
               "is_automated" => false,
               "name" => "wma55/u1210sshd",
               "star_count" => 0},
              {"description" => "",
               "is_official" => false,
               "is_automated" => false,
               "name" => "jdswinbank/sshd",
               "star_count" => 0}
          ]
        end
      end
    end
  end
end
