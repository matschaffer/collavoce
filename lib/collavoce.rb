require 'logger'

module Collavoce
  def self.device_name
    @device_name
  end

  def self.device_name=(device_name)
    @device_name = device_name
  end

  def self.logger
    @logger ||= Logger.new(STDERR)
  end
end

require 'collavoce/note'
require 'collavoce/voice'
require 'collavoce/device_resolver'
require 'collavoce/tracker'
require 'collavoce/sigint'
