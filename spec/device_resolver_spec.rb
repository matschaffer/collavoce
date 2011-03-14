require 'spec_helper'

describe Collavoce::DeviceResolver do
  before(:each) do
    Collavoce.logger.stubs(:info)
    @resolver = Collavoce::DeviceResolver.new
  end

  it "tells the user if there are no output devices" do
    @resolver.stubs(:output_devices).returns([])
    expect { @resolver.resolve }.to raise_error(RuntimeError, /No output devices/)
  end

  it "tells the user if the requested device wasn't found" do
    Collavoce.device_name = "bob"
    @resolver.stubs(:output_devices).returns([])
    expect { @resolver.resolve }.to raise_error(RuntimeError, /bob/)
  end

  def make_mock_device(name)
    info = stub_everything('info')
    info.stubs(:get_name).returns(name)

    receiver = stub_everything('receiver')

    device = stub_everything('device')
    device.stubs(:get_device_info).returns(info)

    device.stubs(:get_receiver).returns(receiver)
    device
  end

  it "picks the first device if no device was specified" do
    Collavoce.device_name = nil
    mock_device = make_mock_device('not bob')
    @resolver.stubs(:output_devices).returns([mock_device])
    @resolver.resolve.should == mock_device.get_receiver
  end

  it "uses the output device specifed by Collavoce.device" do
    Collavoce.device_name = "bob"
    mock_device = make_mock_device('bob')
    @resolver.stubs(:output_devices).returns([make_mock_device('not bob'), mock_device])
    @resolver.resolve.should == mock_device.get_receiver
  end
end
