#!/usr/bin/env ruby
# encoding: utf-8
require 'pp'
require 'rexml/document'
require 'rexml/parseexception'
require 'open3'
require 'active_support/core_ext'
require 'json'
require 'logger'

module OriginModule
  def command_exe(command) # able to be on ruby 1.9.2
    result = []
    status = Hash.new
    begin
      result = Open3.capture3(command)
    rescue Exception => error
      status[:stdout]     = ""
      status[:sterr]      = error.message
      status[:exitstatus] = 1
      #puts error.backtrace.inspect
      return status
    end
    status[:stdout]     = result[0]
    status[:sterr]      = result[1]
    status[:exitstatus] = result[2].exitstatus
    return status
  end

end

include OriginModule

class NumberLogger < Logger
  def initialize(x)
    super
  end
end

class NumberStudentError < StandardError; end

class NumberStudent
  attr_accessor :ipv6_prefix, :prefix_length, :isp_code
  def initialize(id)
    @ipv6_prefix = ""
    @prefix_length = ""
    @isp_code    = ""
    @logger = NumberLogger.new("#{File.expand_path(File.dirname(__FILE__))}/log/ope_tool.log")
    @logger.progname = self.class
    @logger.formatter = proc{|severity, datetime, progname, message|
       "#{datetime}: #{progname}: #{severity}: #{message}\n"
    }
    self.subs_id = id

  end

end

DIR_ROOT = "#{File.expand_path(File.dirname(__FILE__))}"
memberlist_file = "#{DIR_ROOT}/members.yml"
members = YAML.load(File.read(memberlist_file))

shuffles = 1000
shuffles.times do |n|
  members.shuffle!
  printf("shuffle!! %5d回目\n",n+1) if ((n+1) % 100) == 0
end

puts "==結果=="
n = members.length
n.times do |n|
  printf("%3d => %s\n",n+1,members[n])
end
