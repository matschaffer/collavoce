module Collavoce
  class Voice
    attr_accessor :notes, :device

    def self.notes(notes)
      @notes = notes
    end

    def self.channel(channel)
      @channel = channel
    end

    def self.new(options = {})
      super({:notes => @notes, :channel => @channel}.merge(options))
    end

    def initialize(options = {})
      @device       = options[:device]
      @channel      = (options[:channel] || 1) - 1
      @notes        = options[:notes].map { |n| Note.new(n) }
      @bpm          = options[:bpm] || 120
      @bar_duration = (60.to_f / @bpm) * 4
    end

    def send_note(note, channel)
      note.play(device, channel, @bar_duration)
    end

    def play(this_many = 1)
     this_many.times do
       @notes.each do |note|
         break unless Collavoce.running
         send_note(note, @channel)
       end
     end
    end

    def run
      play
    end

    def mod_notes(*indices)
      if indices.empty?
        notes_to_mod = notes
      else
        notes_to_mod = notes.values_at(*indices)
      end
      notes_to_mod.each do |n|
        yield n
      end
    end

    def dim_notes(*indices)
      mod_notes(*indices) do |n|
        n.dim!
      end
    end

    def aug_notes(*indices)
      mod_notes(*indices) do |n|
        n.aug!
      end
    end
  end
end
