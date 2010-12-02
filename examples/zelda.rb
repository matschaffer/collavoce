require 'collavoce'

class Melody < Collavoce::Voice
  channel 1
  notes %w(G#e Be C#5e D5e) 

  def step_down
    mod_notes(0, 1, &:dim!)
  end

  def play_with
    yield
    play(4)
  end

  def run
    3.times do
      play_with { step_down }
    end
    play_with { step_down; notes[2].dim! }
    2.times do
      play_with { notes[0].dim! }
    end
  end
end

class BassPart1 < Collavoce::Voice
  channel 2
  notes %w(G3wqe Bb3qe D Dbh Gb3hw)

  def run
    play
    mod_notes(0, 1, 4, &:dim!)
    mod_notes(&:dim!)
    play
  end
end

class BassPart2 < Collavoce::Voice
  channel 2
  notes %w(Eb3w G3h Ebqe D)
end

Collavoce::Tracker.new(
  [Melody],
  [BassPart1, BassPart2]
).run(240)
