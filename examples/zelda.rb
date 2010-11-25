require 'collavoce'

class Melody < Collavoce::Voice
  def step_down
    notes[0] -= 1
    notes[1] -= 1
  end

  def play_with(&block)
    instance_eval(&block)
    play(4)
  end

  def self.run
    Thread.new do
      v = new(:channel => 1, :notes => %w(G# B C#5 D5))
      3.times do
        v.play_with { step_down }
      end
      v.play_with { step_down; notes[2] -= 1 }
      2.times do
        v.play_with { notes[0] -= 1 }
      end
    end
  end
end

class BassLine < Collavoce::Voice
  def tempo
    W
  end

  def self.run
    Thread.new do
      v = new(:channel => 2, :notes => %w(B A#))
      v.play(4)
    end
  end
end

Melody.run.join
