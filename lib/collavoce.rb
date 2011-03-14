module Collavoce
  def self.device_name
    @device_name
  end

  def self.device_name=(device_name)
    @device_name = device_name
  end
end

require 'collavoce/note'
require 'collavoce/voice'
require 'collavoce/device_resolver'
require 'collavoce/tracker'
require 'collavoce/sigint'
