require 'collavoce'

class Melody < Collavoce::Voice
  def step_down
    notes[0].dim!
    notes[1].dim!
  end

  def play_with(&block)
    instance_eval(&block)
    play(4)
  end

  def self.run
    Thread.new do
      v = new(:channel => 1, :notes => %w(G#e Be C#5e D5e))
      3.times do
        v.play_with { step_down }
      end
      v.play_with { step_down; notes[2].dim! }
      2.times do
        v.play_with { notes[0].dim! }
      end
    end
  end
end

class BassLine < Collavoce::Voice
  def self.run
    Thread.new do
      v = new(:channel => 2, :notes => %w(B A#))
      v.play(4)
    end
  end
end

Melody.run.join
