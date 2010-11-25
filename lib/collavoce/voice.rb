module Collavoce
  class Voice
    include Java
  
    MidiSystem = javax.sound.midi.MidiSystem
    ShortMessage = javax.sound.midi.ShortMessage
  
    BPM = 160
 
    Timings = {1 => (60.to_f / BPM) * 4}
    Timings[2]   = Timings[1]  / 2
    Timings[4]   = Timings[2]  / 2
    Timings[8]   = Timings[4]  / 2
    Timings[16]  = Timings[8]  / 2
    Timings[32]  = Timings[16] / 2

    attr_accessor :notes
  
    def initialize(options = {})
      @channel = (options.delete(:channel) || 1) - 1
      @notes   = options.delete(:notes).map { |n| Note.new(n) }
    end

    def device
      all = MidiSystem.get_midi_device_info.to_a
      possible = all.select { |i| i.get_name == "Bus 1" }
      devices = possible.map { |i| MidiSystem.get_midi_device(i) }
      device = devices.select { |d| d.get_max_receivers != 0 }.first
      device.tap(&:open)
    end
  
    def receiver
      return @receiver if @receiver
      @receiver = device.get_receiver
    end
  
    def send_note(note, channel)
      noteon = ShortMessage.new
      noteon.set_message(ShortMessage::NOTE_ON, channel, note.value, 127);
      noteoff = ShortMessage.new
      noteoff.set_message(ShortMessage::NOTE_OFF, channel, note.value, 127);
      receiver.send(noteon, 0)
      sleep Timings[note.division]
      receiver.send(noteoff, 0)
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
