# coding: utf-8
require 'minitest/autorun'
require 'minitest/pride'

require 'vcr_setup'

require "./kigo_connector"

class KigoConnectorTest < MiniTest::Test

  def test_list_properties_v1
    VCR.use_cassette("list_properties_v1") do
      properties = KigoConnector::V1::Property.list
      refute_empty properties
    end
  end

  def test_ping
    VCR.use_cassette("ping_api_v1") do
      response = KigoConnector::V1.ping
      assert_equal "", response.data
    end
  end

  def test_get_property_info
    VCR.use_cassette("property_info_v1") do
      property = KigoConnector::V1::Property.new(62637)
      assert_equal "B34.2.3 | Sky Terrace Güell III", property.info["PROP_NAME"]
    end
  end

  def test_calendar
    VCR.use_cassette("calendars_v1") do
      calendars = KigoConnector::V1::Calendar.list(nil)
      refute_empty calendars
      assert_equal "2014-10-01", calendars.first.check_in.to_s
    end
  end

  def test_real_time_price_calculation
    VCR.use_cassette("real_time_pricing_v1") do
      property = KigoConnector::V1::Property.new(62637)
      price_info = property.real_time_pricing_calculaton("2015-07-28", "2015-07-31", 4)
      assert_equal "515.64", price_info["TOTAL_AMOUNT"]
    end
  end

  def test_property_rate
    VCR.use_cassette("property_pricing_setup_v1") do
      property = KigoConnector::V1::Property.new(62637)
      assert_equal 36, property.periods.size
    end
  end

end
