require "spec_helper"

RSpec.describe KigoConnector::V1::ApiCall do

  describe "#api_request" do

    context "on bad request" do

      it "raises ApiCallError exception" do
        expect {
          KigoConnector::V1::ApiCall.api_request("foo", {})
        }.to raise_exception KigoConnector::V1::ApiCallError
      end

    end

  end
end
