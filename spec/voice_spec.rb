require 'spec_helper'

class TestVoice < Collavoce::Voice
  channel 3
  notes %w(C D E F)
end

class ChildWithNotes < TestVoice
  notes %w(C D E F)
end

class ChildWithoutNotes < TestVoice
end

describe Collavoce::Voice do
  before(:each) do
    @device = stub('device', :send => nil)
    @voice = TestVoice.new(:bpm => 60, :device => @device)
  end

  it "plays the contained notes" do
    Collavoce::Note.any_instance.expects(:play).times(4)
    @voice.play
  end

  it "plays notes on the specified 1-indexed channel (internal is 0-indexed)" do
    Collavoce::Note.any_instance.expects(:play).with(@device, 2, 4).times(4)
    @voice.play
  end

  it "should channel from parent" do
    Collavoce::Note.any_instance.expects(:play).with(@device, 2, 4).times(4)
    ChildWithNotes.new(:bpm => 60, :device => @device).play
  end

  it "should channel from parent" do
    Collavoce::Note.any_instance.expects(:play).with(@device, 2, 4).times(4)
    ChildWithoutNotes.new(:bpm => 60, :device => @device).play
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

  it "doesn't play after Collavoce.stop is called" do
    Collavoce.stop
    Collavoce::Note.any_instance.expects(:play).never
    @voice.play
  end
end

