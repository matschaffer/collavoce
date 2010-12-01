require 'collavoce'

class Melody < Collavoce::Voice
  channel 1
  notes %w(G#e Be C#5e D5e) 

  def step_down
    notes[0].dim!
    notes[1].dim!
  end

  def play_with(&block)
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

class BassLine < Collavoce::Voice
  channel 2
  notes %w(B A#)

  def run
    play(4)
  end
end

Melody.new.run
