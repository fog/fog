# encoding: utf-8

Shindo.tests('AWS | signed_params', ['aws']) do
  returns( Fog::AWS.escape( "'Stöp!' said Fred_-~." ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-~." }

  tests('Keys can contain a hierarchical prefix which should not be escaped') do
    returns( Fog::AWS.escape( "key/with/prefix" ) ) { "key/with/prefix" }
  end

  tests('Keys should be canonicalised using Unicode NFC') do
    returns( Fog::AWS.escape( "\u{00e9}" ) ) { "%C3%A9" }

    tests('Characters with combining mark should be combined and then escaped') do
      returns( Fog::AWS.escape( "\u{0065}\u{0301}" ) ) { "%C3%A9" }
    end
  end
end
