# coding: utf-8
require "spec_helper"

RSpec.describe KigoConnector::Property do

  context "V1 API" do
    describe "#list_properties" do

      it "returns a list of properties" do
        VCR.use_cassette("list_properties_v1") do
          properties = KigoConnector::Property.list
          expect(properties.size).to be > 0
        end
      end
    end

    describe "#info" do

      context "for an existing/accesible property" do

        it "returns info for a property" do
          VCR.use_cassette("property_info_v1") do
            property = KigoConnector::Property.new(id: 62637)
            expect(property.info["PROP_NAME"]).to eq "B34.2.3 | Sky Terrace Güell III"
          end
        end
      end

      context "for a non existing/accesible property" do

        it "raises ApiCallError" do
          VCR.use_cassette("property_info_v1") do
            property = KigoConnector::Property.new(id: 999999999999)
            expect { property.info["PROP_NAME"].to raise_exception KigoConnector::ApiCallError }
          end
        end

      end
    end


    describe "#real_time_pricing_calculation" do

      it "returns price info" do
        VCR.use_cassette("real_time_pricing_v1", match_requests_on: [:method, :uri]) do
          property = KigoConnector::Property.new(id: 62637)
          price_info = property.real_time_pricing_calculaton(check_in: "2015-07-28", check_out: "2015-07-31", guests: 4)
          expect(price_info["TOTAL_AMOUNT"]).to eq "515.64"
        end
      end

    end

    describe "#periods" do

      it "returns period rates' info" do
        VCR.use_cassette("property_pricing_setup_v1") do
          property = KigoConnector::Property.new(id: 62637)
          expect(property.periods.size).to eq 36
        end
      end

    end
  end

  context "V2 API" do

    describe "#list_properties" do

      it "returns a list of properties" do
        VCR.use_cassette("list_properties_v2") do
          properties = KigoConnector::Property.list(api_version: "2")
          expect(properties.size).to be > 0
        end
      end

    end

    describe "#info" do

      context "for an existing/accesible property" do

        it "returns info for a property" do
          VCR.use_cassette("property_info_v2") do
            property = KigoConnector::Property.new(id: 155091, api_version: "2")
            expect(property.info["PROP_NAME"]).to eq "The Lofts at Park Crest  (2 BR)"
          end
        end

      end

      context "for a non existing/accesible property" do

        it "raises ApiCallError" do
          VCR.use_cassette("property_info_v2") do
            property = KigoConnector::Property.new(id: 62637, api_version: "2")
            expect { property.info["PROP_NAME"].to raise_exception KigoConnector::ApiCallError }
          end
        end
      end
    end

    describe "#real_time_pricing_calculation" do

      it "returns price info" do
        VCR.use_cassette("real_time_pricing_v2", match_requests_on: [:method, :uri]) do
          property = KigoConnector::Property.new(id: 155091, api_version: "2")
          price_info = property.real_time_pricing_calculaton(check_in: "2015-08-28", check_out: "2015-08-31", guests: 4)
          expect(price_info["TOTAL_AMOUNT"]).to eq "1766.74"
        end
      end

    end

    describe "#periods" do

      it "returns period rates' info" do
        VCR.use_cassette("property_pricing_setup_v2") do
          property = KigoConnector::Property.new(id: 155091, api_version: "2")
          expect(property.periods.size).to eq 5
        end
      end

    end
  end

end
