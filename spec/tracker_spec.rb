require 'spec_helper'

class MelodyA < Collavoce::Voice
  notes %w(C D E)
end

class MelodyB < Collavoce::Voice
  notes %w(F G)
end

describe Collavoce::Tracker do
  before(:each) do
    Collavoce::DeviceResolver.any_instance.stubs(:resolve)
  end

  it "should play a list of voices" do
    MelodyA.any_instance.expects(:run)
    MelodyB.any_instance.expects(:run)
    @tracker = Collavoce::Tracker.new([MelodyA, MelodyB])
    @tracker.run
  end

  it "should play multiple tracks (in parallel)" do
    MelodyA.any_instance.expects(:run)
    MelodyB.any_instance.expects(:run)
    @tracker = Collavoce::Tracker.new([MelodyA],
                                      [MelodyB])
    @tracker.run
  end
end
