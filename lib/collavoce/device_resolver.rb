module Collavoce
  class DeviceResolver
    MidiSystem = Java::javax.sound.midi.MidiSystem

    def output_devices
      devices = MidiSystem.get_midi_device_info.to_a.map do |info|
        MidiSystem.get_midi_device(info)
      end
      devices.select do |device|
        device.get_max_receivers != 0
      end
    end

    def output_device_names
      output_devices.map(&:get_device_info).map(&:get_name)
    end

    def resolve
      Collavoce.logger.info do
        "Available output devices: #{output_device_names.join(', ')}"
      end

      name = Collavoce.device_name
      selected_device = output_devices.detect do |device|
        device.get_device_info.get_name == name
      end

      if !selected_device
        raise "Couldn't find device called #{name}" if name
        raise "No output devices available" if output_devices.empty?
        selected_device = output_devices.first
        Collavoce.logger.info do
          "Defaulted to device: #{selected_device.get_device_info.get_name}"

        end
      end

      selected_device.open
      selected_device.get_receiver
    end
  end
end
