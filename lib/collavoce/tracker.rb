module Collavoce
  class Tracker
    def initialize(*tracks)
      @tracks = tracks
      @device = DeviceResolver.new.resolve
    end

    def run(bpm = 120)
      @threads = []
      @tracks.each do |track|
        @threads << Thread.new do
          track.each do |voice|
            voice.new(:bpm => bpm, :device => @device).run
          end
        end
      end
      @threads.map(&:join)
    end

    def loop(bpm=120)
      run(bpm) while true
    end
  end
end
