require 'spec_helper'

class TestVoice < Collavoce::Voice
  channel 3
  notes %w(C D E F)
end

describe Collavoce::Voice do
  before(:each) do
    @receiver = mock('receiver')
    @voice = TestVoice.new(:bpm => 60)
    @voice.stubs(:receiver).returns(@receiver)
    @receiver.stubs(:send)
  end

  it "plays notes to the system receiver" do
    Collavoce::Note.any_instance.expects(:play).times(4)
    @voice.play
  end

  it "plays notes on the specified 1-indexed channel (internal is 0-indexed)" do
    Collavoce::Note.any_instance.expects(:play).with(@receiver, 2, 4).times(4)
    @voice.play
  end

  it "has helpers for modifying groups of notes" do
    @voice.mod_notes(&:dim!)
    @voice.notes[0].should == Collavoce::Note.new("Cb")
    @voice.notes[1].should == Collavoce::Note.new("Db")
    @voice.mod_notes(2, 3, &:aug!)
    @voice.notes[2].should == Collavoce::Note.new("E")
    @voice.notes[3].should == Collavoce::Note.new("F")
  end

  it "has helpers for diminishing and augmenting notes" do
    @voice.dim_notes
    @voice.notes[0].should == Collavoce::Note.new("Cb")
    @voice.notes[1].should == Collavoce::Note.new("Db")
    @voice.aug_notes(2, 3)
    @voice.notes[2].should == Collavoce::Note.new("E")
    @voice.notes[3].should == Collavoce::Note.new("F")
  end

  it "stops playing when Collavoce.stop is called" do
    Collavoce.stop
    Collavoce::Note.any_instance.expects(:play).never
    @voice.play
  end

  it "tells the user if there are no output devices" do
    @voice.stubs(:output_devices).returns([])
    expect { @voice.device }.to raise_error(RuntimeError, /No output devices/)
  end

  it "tells the user if the requested device wasn't found" do
    Collavoce.device_name = "bob"
    @voice.stubs(:output_devices).returns([])
    expect { @voice.device }.to raise_error(RuntimeError, /bob/)
  end

  def make_mock_device(name)
    info = stub_everything('info')
    info.stubs(:get_name).returns(name)
    device = stub_everything('device')
    device.stubs(:get_device_info).returns(info)
    device
  end


  it "picks the first device if no device was specified" do
    Collavoce.device_name = nil
    mock_device = make_mock_device('not bob')
    @voice.stubs(:output_devices).returns([mock_device])
    $stderr.stubs(:puts)
    @voice.device.should == mock_device
  end

  it "uses the output device specifed by Collavoce.device" do
    Collavoce.device_name = "bob"
    mock_device = make_mock_device('bob')
    @voice.stubs(:output_devices).returns([make_mock_device('not bob'), mock_device])
    @voice.device.should == mock_device
  end
end

