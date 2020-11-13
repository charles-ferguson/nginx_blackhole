#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'fileutils'

set :bind, '0.0.0.0'
set :port, 4567

LUA_KILLSWITCH = './killswitches/uri/lua'
post '/kill/lua' do
  dirname = File.dirname(LUA_KILLSWITCH)

  FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
  FileUtils.touch(LUA_KILLSWITCH)
end

delete '/kill/lua' do
  File.unlink(LUA_KILLSWITCH) if File.exist?(LUA_KILLSWITCH)
end

get '/*' do
  "Hi, you hit: #{request.path_info}"
end
