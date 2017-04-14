#!/usr/bin/ruby

require 'base64'

hash = ARGV[0]

print Base64.decode(hash)
