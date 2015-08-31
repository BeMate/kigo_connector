require "spec_helper"

RSpec.describe KigoConnector::ApiCall do

  describe "#api_request" do

    context "on bad request" do

      it "raises ApiCallError exception" do
        expect {
          KigoConnector::ApiCall.api_request("foo", {})
        }.to raise_exception KigoConnector::ApiCallError
      end

    end

  end
end
