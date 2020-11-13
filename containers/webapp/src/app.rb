#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'pry'
require 'fileutils'

set :bind, '0.0.0.0'
set :port, 4567

class Blackhole
  BLACKHOLE_PATH = ENV.fetch('BLACKHOLE_PATH', './blackholes').to_s.freeze
  TYPE_TO_BLACKHOLE_PATH_MAP = {
    ip: File.join(BLACKHOLE_PATH, '/ip'),
    uri: File.join(BLACKHOLE_PATH, '/uri')
  }.freeze

  def self.ensure_setup
    TYPE_TO_BLACKHOLE_PATH_MAP.values.each do |path|
      FileUtils.mkdir_p(path) unless File.directory?(path)
    end
  end

  def self.for(ips: [], uris: [])
    blackholes = ips.map { |ip| new(ip, type: :ip) }
    blackholes.concat(uris.map { |uri| new(uri, type: :uri) })
  end

  attr_reader :identifier, :type
  def initialize(identifier, type:)
    unless TYPE_TO_BLACKHOLE_PATH_MAP.keys.include?(type)
      raise "Type needs to be one of [#{TYPE_TO_BLACKHOLE_PATH_MAP.keys.join(', ')}]"
    end

    @identifier = identifier
    @type = type
  end

  def path
    file_name = identifier.gsub('/', '_')
    File.join(TYPE_TO_BLACKHOLE_PATH_MAP[type], file_name)
  end

  def create
    FileUtils.touch(path)
  end

  def destroy
    File.unlink(path)
  rescue Errno::ENOENT
    puts 'Already gone'
  end
end

Blackhole.ensure_setup

post '/blackhole' do
  begin
    params.merge!(JSON.parse(request.body.read))
  rescue JSON::ParseError
    return [402, 'Expected body to be valid json']
  end

  ips = Array(params['ip'])
  uris = Array(params['uri'])
  blackholes = Blackhole.for(ips: ips, uris: uris)

  case params['action']
  when 'create'
    blackholes.map(&:create)
    201
  when 'destroy'
    blackholes.map(&:destroy)
    201
  else
    [402, <<~EOERROR]
      Expected to find a json body with an action parameter of either create or destroy
      Example
        { "action": "create", "ip": ["127.0.0.1"], "uri": ["foo"] }
    EOERROR
  end
end

get '/*' do
  "Hi, you hit: #{request.path_info}"
end
