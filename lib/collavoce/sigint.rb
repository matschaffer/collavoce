module Collavoce
  def self.stop
    @running = false
  end

  def self.running
    @running.nil? || @running
  end
end

trap("INT") do
  Collavoce.stop
end
