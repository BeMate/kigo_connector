require "spec_helper"

RSpec.describe KigoConnector::Calendar do

  describe "#list" do

    it "returns a list of avalavility calendars" do
      VCR.use_cassette("calendars_v1") do
        calendars = KigoConnector::Calendar.list(nil)
        expect(calendars.size).to be > 0
        expect(calendars.first.check_in.to_s).to eq "2014-10-01"
      end
    end

  end

end
