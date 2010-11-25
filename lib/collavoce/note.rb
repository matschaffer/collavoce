module Collavoce
  class Note
    class UnparsableError < RuntimeError; end

    attr_accessor :value
    attr_accessor :division

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
      "h" => 2,
      "q" => 4,
      "e" => 8,
      "s" => 16,
      "t" => 32
    }

    def initialize(note)
      match = note.match(/^([ABCDEFGR])([#]*)?([b]*)?(\d)?([whqest])?/)

      raise UnparsableError.new("Couldn't parse note: #{note}") unless match

      @division = DIVISIONS[match[5] || "q"]

      if base_value = NOTES[match[1]]
        offset = (match[2] || "").length
        offset -= (match[3] || "").length
        octave = (match[4] || "4").to_i
        @value = base_value + ((octave - 4) * 12) + offset
      end
    end
  end
end
