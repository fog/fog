Shindo.tests('AWS::Glacier | glacier tree hash calcuation', ['aws']) do

  tests('tree_hash(single part < 1MB)') do
    returns(Digest::SHA256.hexdigest('')) { Fog::AWS::Glacier::TreeHash.digest('')}
  end

  tests('tree_hash(multibyte characters)') do
    body = ("\xC2\xA1" * 1024*1024)
    body.force_encoding('UTF-8') if body.respond_to? :encoding

    expected = Digest::SHA256.hexdigest(
                Digest::SHA256.digest("\xC2\xA1" * 1024*512) + Digest::SHA256.digest("\xC2\xA1" * 1024*512)
              )
    returns(expected) { Fog::AWS::Glacier::TreeHash.digest(body)}
  end

  tests('tree_hash(power of 2 number of parts)') do
    body = ('x' * 1024*1024) + ('y'*1024*1024) + ('z'*1024*1024) + ('t'*1024*1024)
    expected = Digest::SHA256.hexdigest(
                 Digest::SHA256.digest(
                    Digest::SHA256.digest('x' * 1024*1024) + Digest::SHA256.digest('y' * 1024*1024)
                 ) +
                 Digest::SHA256.digest(
                   Digest::SHA256.digest('z' * 1024*1024) + Digest::SHA256.digest('t' * 1024*1024)
                 )
               )

    returns(expected) { Fog::AWS::Glacier::TreeHash.digest(body)}
  end

  tests('tree_hash(non power of 2 number of parts)') do
    body = ('x' * 1024*1024) + ('y'*1024*1024) + ('z'*1024*1024)
    expected = Digest::SHA256.hexdigest(
                 Digest::SHA256.digest(
                    Digest::SHA256.digest('x' * 1024*1024) + Digest::SHA256.digest('y' * 1024*1024)
                 ) +
                 Digest::SHA256.digest('z' * 1024*1024)
               )

    returns(expected) { Fog::AWS::Glacier::TreeHash.digest(body)}
  end

  tests('multipart') do
    tree_hash = Fog::AWS::Glacier::TreeHash.new
    part = ('x' * 1024*1024) + ('y'*1024*1024)
    returns(Fog::AWS::Glacier::TreeHash.digest(part)) { tree_hash.add_part part }

    tree_hash.add_part('z'* 1024*1024 + 't'*1024*1024)

    expected = Digest::SHA256.hexdigest(
                 Digest::SHA256.digest(
                    Digest::SHA256.digest('x' * 1024*1024) + Digest::SHA256.digest('y' * 1024*1024)
                 ) +
                 Digest::SHA256.digest(
                   Digest::SHA256.digest('z' * 1024*1024) + Digest::SHA256.digest('t' * 1024*1024)
                 )
               )
    returns(expected) { tree_hash.hexdigest}

  end

end
