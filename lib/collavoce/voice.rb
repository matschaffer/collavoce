module Collavoce
  class Voice
    include Java
  
    MidiSystem = javax.sound.midi.MidiSystem
    ShortMessage = javax.sound.midi.ShortMessage
  
    BPM = 160
  
    W = (60.to_f / BPM) * 4
    H = W / 2
    Q = H / 2
    E = Q / 2
    S = Q / 2
    T = S / 2
  
    # TODO maths
    # C4 == 60
    NOTES = {
      "G" => 67,
      "G#" => 68,
      "A#" => 70,
      "B" => 71,
      "C#5" => 73,
      "D5" => 74
    }
  
    attr_accessor :notes
  
    def initialize(options = {})
      @channel = (options.delete(:channel) || 1) - 1
      @notes   = options.delete(:notes).map { |n| NOTES[n] }
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
  
    def send_note(note, time, channel)
      noteon = ShortMessage.new
      noteon.set_message(ShortMessage::NOTE_ON, channel, note, 127);
      noteoff = ShortMessage.new
      noteoff.set_message(ShortMessage::NOTE_OFF, channel, note, 127);
      receiver.send(noteon, 0)
      sleep time
      receiver.send(noteoff, 0)
    end
  
    def tempo
      S
    end
  
    def play(this_many = 1)
     this_many.times do
       @notes.each do |note|
         send_note(note, tempo, @channel)
       end
     end
    end
  end
end
