module Collavoce
  class Note
    class UnparsableError < RuntimeError; end

    attr_accessor :value
    attr_accessor :duration

    NOTES = {
      "C" => 60,
      "D" => 62,
      "E" => 64,
      "F" => 65,
      "G" => 67,
      "A" => 69,
      "B" => 71,
    }

    DIVISIONS = {
      "w" => 1,
      "h" => 1.to_f / 2,
      "q" => 1.to_f / 4,
      "e" => 1.to_f / 8,
      "s" => 1.to_f / 16,
      "t" => 1.to_f / 32
    }

    def initialize(note)
      case note
      when String
        init_from_string(note)
      when Note
        init_from_note(note)
      end
    end

    def init_from_string(note)
      match = note.match(/^([ABCDEFGR])([#]*)?([b]*)?(\d)?([whqest]*)/)

      raise UnparsableError.new("Couldn't parse note: #{note}") unless match

      if match[5].empty?
        @duration = DIVISIONS["q"]
      else
        @duration = 0
        match[5].each_char do |c|
          @duration += DIVISIONS[c]
        end
      end

      if base_value = NOTES[match[1]]
        offset = (match[2] || "").length
        offset -= (match[3] || "").length
        octave = (match[4] || "4").to_i
        @value = base_value + ((octave - 4) * 12) + offset
      end
    end

    def init_from_note(note)
      @value    = note.value
      @duration = note.duration
    end

    def aug!
      @value += 1
    end

    def dim!
      @value -= 1
    end

    def aug
      copy = Note.new(self)
      copy.aug!
      copy
    end

    def dim
      copy = Note.new(self)
      copy.dim!
      copy
    end
  end
end
