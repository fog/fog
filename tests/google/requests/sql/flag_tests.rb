Shindo.tests('Fog::Google[:sql] | flag requests', ['google']) do
  @sql = Fog::Google[:sql]

  @get_flag_format = {
    'name' => String,
    'allowedStringValues' => Fog::Nullable::Array,
    'appliesTo' => Array,
    'kind' => String,
    'maxValue' => Fog::Nullable::String,
    'minValue' => Fog::Nullable::String,
    'type' => String,
  }

  @list_flags_format = {
    'kind' => String,
    'items' => [@get_flag_format],
  }

  tests('success') do

    tests('#list_flags').formats(@list_flags_format) do
      @sql.list_flags.body
    end

  end

end
