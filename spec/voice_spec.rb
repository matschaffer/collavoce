require 'spec_helper'

class TestVoice < Collavoce::Voice
  channel 3
  notes %w(C D E F)
end

describe Collavoce::Voice do
  ShortMessage = Collavoce::Voice::ShortMessage

  let(:receiver) { mock("receiver") }

  before(:each) do
    @voice = TestVoice.new(:bpm => 60)
    @voice.stubs(:receiver).returns(receiver)
    receiver.stubs(:send)
  end

  it "plays notes to the system receiver" do
    receiver.expects(:send).with(is_a(ShortMessage), 0).times(8)
    @voice.expects(:sleep).with(1).times(4)
    @voice.play
  end

  it "plays notes on the specified 1-indexed channel (internal is 0-indexed)" do
    ShortMessage.any_instance.expects(:set_message).with(anything, 2, anything, anything).times(8)
    @voice.expects(:sleep).with(1).times(4)
    @voice.play
  end

  it "should just pause on rests" do
    @voice.notes = [ Collavoce::Note.new("R") ]
    ShortMessage.any_instance.expects(:set_message).never
    @voice.expects(:sleep).with(1)
    @voice.play
  end
end

