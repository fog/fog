# encoding: utf-8

Shindo.tests('AWS | signed_params', ['aws']) do
  returns( Fog::AWS.escape( "'Stöp!' said Fred_-~./" ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-~.%2F" }

  tests('Keys should be canonicalised using Unicode NFC') do
    returns( Fog::AWS.escape( ["00E9".to_i(16)].pack("U*") ) ) { "%C3%A9" }

    tests('Characters with combining mark should be combined and then escaped') do
      returns( Fog::AWS.escape( ["0065".to_i(16), "0301".to_i(16)].pack("U*") ) ) { "%C3%A9" }
    end
  end
end
