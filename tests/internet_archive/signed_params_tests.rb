# encoding: utf-8

Shindo.tests('InternetArchive | signed_params', ['internet_archive']) do
  returns( Fog::InternetArchive.escape( "'Stöp!' said Fred_-~." ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-~." }
end
