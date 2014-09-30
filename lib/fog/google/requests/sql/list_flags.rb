module Fog
  module Google
    class SQL
      ##
      # List all available database flags for Google Cloud SQL instances
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/flags/list

      class Real
        def list_flags
          api_method = @sql.flags.list
          parameters = {}

          request(api_method, parameters)
        end
      end

      class Mock
        def list_flags
          body = {
            'kind' => 'sql#flagsList',
            'items' => [
              {
                'kind' => 'sql#flag',
                'name' => 'log_output',
                'type' => 'STRING',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'allowedStringValues' => ['TABLE', 'NONE'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'general_log',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'log_queries_not_using_indexes',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'log_bin_trust_function_creators',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'slow_query_log',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'read_only',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'max_allowed_packet',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '16384',
                'maxValue' => '1073741824',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'long_query_time',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '0',
                'maxValue' => '30000000',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'group_concat_max_len',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '4',
                'maxValue' => '17179869184',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'wait_timeout',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '1',
                'maxValue' => '31536000',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'innodb_lock_wait_timeout',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '1',
                'maxValue' => '1073741824',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'lower_case_table_names',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '0',
                'maxValue' => '2',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'innodb_flush_log_at_trx_commit',
                'type' => 'INTEGER',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'minValue' => '0',
                'maxValue' => '2',
              },
              {
                'kind' => 'sql#flag',
                'name' => 'skip_show_database',
                'type' => 'NONE',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'event_scheduler',
                'type' => 'BOOLEAN',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
              },
              {
                'kind' => 'sql#flag',
                'name' => 'character_set_server',
                'type' => 'STRING',
                'appliesTo' => ['MYSQL_5_5', 'MYSQL_5_6'],
                'allowedStringValues' => ['utf8', 'utf8mb4'],
              },
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
