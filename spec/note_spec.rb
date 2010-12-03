require 'spec_helper'

describe Collavoce::Note do
  Note = Collavoce::Note

  it "converts basic notes" do
    Note.new("C").value.should == 60
    Note.new("D").value.should == 62
  end

  it "converts sharps and flats" do
    Note.new("C#").value.should  == 61
    Note.new("C##").value.should == 62
    Note.new("Eb").value.should  == 63
    Note.new("Ebb").value.should == 62
  end

  it "converts octaves" do
    Note.new("C5").value.should == 72
    Note.new("C3").value.should == 48
  end

  it "converts duration" do
    Note.new("C5w").duration.should  == 1
    Note.new("C#5h").duration.should == 1.to_f / 2
    Note.new("Db3q").duration.should == 1.to_f / 4
    Note.new("Ee").duration.should   == 1.to_f / 8
    Note.new("Fbs").duration.should  == 1.to_f / 16
    Note.new("G#t").duration.should  == 1.to_f / 32

    Note.new("C").duration.should    == 1.to_f / 4
  end

  it "converts complex durations" do
    Note.new("C#5hs").duration.should == 1.to_f / 2 + 1.to_f / 16
  end

  it "converts rests" do
    Note.new("Rs").value.should be_nil
    Note.new("Rs").duration.should == 1.to_f / 16
  end

  it "augments and diminshes" do
    c = Note.new("C")
    c.value.should == 60
    c.aug.value.should == 61
    c.dim.value.should == 59
    c.dim!
    c.value.should == 59
    c.aug!
    c.value.should == 60
  end

  it "raises a useful exception if the note isn't parsable" do
    lambda { Note.new("OMFG") }.should raise_error(Collavoce::Note::UnparsableError)
  end

  it "knows about equality" do
    Note.new("C").should == Note.new("C")
    Note.new("C").should_not == Note.new("D")
    Note.new("Cs").should_not == Note.new("Ce")
  end

  it "should play itself on a receiver" do
    @receiver = mock('receiver')
    @note = Note.new("C")

    @receiver.expects(:send).with(is_a(Note::ShortMessage), 0).twice
    @note.expects(:sleep).with(1)

    @note.play(@receiver, 0, 4)
  end

  it "should just pause on rests" do
    @note = Note.new("R")
    @note.expects(:sleep).with(1)
    @note.play(nil, nil, 4)
  end
end
