module Collavoce
  class Voice
    include Java
  
    MidiSystem = javax.sound.midi.MidiSystem
    ShortMessage = javax.sound.midi.ShortMessage
  
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
      duration = @bar_duration * note.duration
      if note.value
        noteon = ShortMessage.new
        noteon.set_message(ShortMessage::NOTE_ON, channel, note.value, 127);
        noteoff = ShortMessage.new
        noteoff.set_message(ShortMessage::NOTE_OFF, channel, note.value, 127);
        receiver.send(noteon, 0)
        sleep duration
        receiver.send(noteoff, 0)
      else
        sleep duration
      end
    end
  
    def play(this_many = 1)
     this_many.times do
       @notes.each do |note|
         send_note(note, @channel)
       end
     end
    end
  end
end
