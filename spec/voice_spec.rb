require 'spec_helper'

describe Collavoce::Voice do
  let(:receiver) { mock("receiver") }

  before(:each) do
    @voice = Collavoce::Voice.new(:bpm => 60, :notes => %w(C D E F))
    @voice.stubs(:receiver).returns(receiver)
  end

  it "plays notes to the system receiver" do
    receiver.expects(:send).with(is_a(Collavoce::Voice::ShortMessage), 0).times(8)
    @voice.expects(:sleep).with(1).times(4)
    @voice.play
  end
end

