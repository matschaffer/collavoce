require 'spec_helper'

describe Collavoce::Note do
  let(:note) { Collavoce::Note }

  it "converts basic notes" do
    note.new("C").value.should == 60
    note.new("D").value.should == 62
  end

  it "converts sharps and flats" do
    note.new("C#").value.should  == 61
    note.new("C##").value.should == 62
    note.new("Eb").value.should  == 63
    note.new("Ebb").value.should == 62 
  end

  it "converts octaves" do
    note.new("C5").value.should == 72
    note.new("C3").value.should == 48
  end

  it "converts division" do
    note.new("C5w").division.should  == 1
    note.new("C#5h").division.should == 2
    note.new("Db3q").division.should == 4
    note.new("Ee").division.should   == 8
    note.new("Fbs").division.should  == 16
    note.new("G#t").division.should  == 32

    note.new("C").division.should    == 4
  end

  it "converts rests" do
    note.new("Rs").value.should be_nil
    note.new("Rs").division.should == 16
  end

  it "augments and diminshes" do
    c = note.new("C")
    c.value.should == 60
    c.aug.value.should == 61
    c.dim.value.should == 59
    c.dim!
    c.value.should == 59
    c.aug!
    c.value.should == 60
  end

  it "raises a useful exception if the note isn't parsable" do
    lambda { note.new("OMFG") }.should raise_error(Collavoce::Note::UnparsableError)
  end
end
