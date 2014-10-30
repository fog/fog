# encoding: utf-8

Shindo.tests('Exoscale | escape', ['Exoscale']) do
  returns( Fog::Exoscale.escape( "'Stöp!' said Fred_-~." ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-%7E." }
end

Shindo.tests('Exoscale | signed_params', ['exoscale']) do
  returns( Fog::Exoscale.signed_params( 'abcdefg', 'account' => 'Lorem Ipsum', 'domainid' => 42, 'q' => 'keywords' ) ) { "V2CxRU4zQQtox1DZsH/66GDdzhg=" }
  returns( Fog::Exoscale.signed_params( 'abcdefg', 'account' => 'Lorem Ipsum', 'domainid' => '42', 'q' => 'keywords' ) ) { "V2CxRU4zQQtox1DZsH/66GDdzhg=" }
  returns( Fog::Exoscale.signed_params( 'abcdefg', 'account' => 'Lorem Ipsum', 'domainid' => 42, 'q' => nil ) ) { "5bsDirm5pPgVoreQ6vquKRN+4HI=" }
  returns( Fog::Exoscale.signed_params( 'abcdefg', 'account' => 'Lorem Ipsum', 'domainid' => 42, 'q' => '' ) ) { "5bsDirm5pPgVoreQ6vquKRN+4HI=" }
end
