#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'

set :bind, '0.0.0.0'
set :port, 4567

get '/*' do
  "Hi, you hit: #{request.path_info}"
end
