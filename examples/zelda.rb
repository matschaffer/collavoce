require 'collavoce'

class Melody1 < Collavoce::Voice
  channel 1
  notes %w(G#e Be C#5e D5e) 

  def play_with
    yield
    play(4)
  end

  def run
    3.times do
      play_with { dim_notes(0, 1) }
    end
    play_with { dim_notes(0, 1, 2) }
    2.times do
      play_with { dim_notes(0) }
    end
    play(4)
  end
end

class BassPart1 < Collavoce::Voice
  channel 2
  notes %w(G3wqe Bb3qe D Dbh Gb3hw)

  def run
    play
    dim_notes(0, 1, 4)
    dim_notes
    play
  end
end

class BassPart2 < Collavoce::Voice
  channel 2
  notes %w(Eb3w G3qes Ebqs D)
  def run
    play
    dim_notes(0, 2, 3)
    play
  end
end

class BassPart3 < Collavoce::Voice
  channel 2
  notes %w(Ch A3h Gb3w)
end

Collavoce::Tracker.new(
  [Melody1],
  [BassPart1, BassPart2, BassPart3]
).run(240)
