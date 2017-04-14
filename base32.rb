#!/usr/bin/ruby

require 'base32'

hash = ARGV[0]

print Base32.decode(hash)
