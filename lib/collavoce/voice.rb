module Collavoce
  class Voice
    def self.notes(notes)
      define_method(:notes) do
        @notes ||= notes.map { |n| Note.new(n) }
      end
    end

    def channel
      0
    end

    def self.channel(channel)
      define_method(:channel) { channel - 1 }
    end

    def initialize(options = {})
      @device       = options[:device]
      @bpm          = options[:bpm] || 120
      @bar_duration = (60.to_f / @bpm) * 4
    end

    def send_note(note)
      note.play(@device, channel, @bar_duration)
    end

    def play(this_many = 1)
     this_many.times do
       notes.each do |note|
         break unless Collavoce.running
         send_note(note)
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
