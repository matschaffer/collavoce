module Collavoce
  class Voice
    MidiSystem = Java::javax.sound.midi.MidiSystem

    attr_accessor :notes

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
      @channel      = (options.delete(:channel) || 1) - 1
      @notes        = options.delete(:notes).map { |n| Note.new(n) }
      @bpm          = options.delete(:bpm) || 120
      @bar_duration = (60.to_f / @bpm) * 4
    end

    def device
      all = MidiSystem.get_midi_device_info.to_a
      possible = all.select { |i| i.get_name == "Bus 1" }
      devices = possible.map { |i| MidiSystem.get_midi_device(i) }
      device = devices.select { |d| d.get_max_receivers != 0 }.first
      device.open
      device
    end

    def receiver
      return @receiver if @receiver
      @receiver = device.get_receiver
    end

    def send_note(note, channel)
      note.play(receiver, channel, @bar_duration)
    end

    def play(this_many = 1)
     this_many.times do
       @notes.each do |note|
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
