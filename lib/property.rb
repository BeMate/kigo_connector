module KigoConnector
  module V1

    class Property
      attr_reader :id, :pricing, :fees, :discounts, :deposit, :currency, :per_guest_charge, :periods

      def initialize(id)
        if !id.nil?
          @id = id
        else
          raise Exception.new("ID is #{id.inspect}")
        end
      end

      def info
        @info ||= read_info
      end

      def pricing
        @rates ||= read_pricing_info
      end

      def fees
        @rates ||= read_pricing_info
        @fees
      end

      def dicounts
        @rates ||= read_pricing_info
        @discounts
      end

      def deposit
        @rates ||= read_pricing_info
        @deposit
      end

      def currency
        @rates ||= read_pricing_info
        @currency
      end

      def per_guest_charge
        @rates ||= read_pricing_info
        @per_guest_charge
      end

      def periods
        @rates ||= read_pricing_info
        @periods
      end

      def real_time_pricing_calculaton(checkin, checkout, guests)
        response = ApiCall.api_request("computePricing",
                                       {"PROP_ID": self.id,
                                        "RES_CREATE":"#{Date.today}",
                                        "RES_CHECK_IN":"#{checkin}",
                                        "RES_CHECK_OUT":"#{checkout}",
                                        "RES_N_ADULTS": guests,
                                        "RES_N_CHILDREN": 0,
                                        "RES_N_BABIES": 0})

        response.data
      end

      def self.list
        response = ApiCall.api_request("listProperties2", nil)

        properties = []
        response.data.each do |property|
          properties << Property.new(property["PROP_ID"])
        end

        properties
      end

      class Period
        attr_reader :check_in, :check_out, :name, :stay_min, :weekly, :nightly_amounts

        def initialize(check_in, check_out, name, stay_min, weekly, nightly_amounts)
          @check_in = Date.parse(check_in)
          @check_out = Date.parse(check_out)
          @name = name
          @stay_min = stay_min
          @weekly = weekly
          @nightly_amounts = nightly_amounts
        end
      end


      private

      Fee = Struct.new(:type_id, :include_in_rent, :unit, :value)
      FeeValue = Struct.new(:stay_from, :unit, :value)
      PerGuestCharge = Struct.new(:type, :standard, :max)

      def read_info
        response = ApiCall.api_request("readProperty2", "PROP_ID": self.id)
        response.data["PROP_INFO"]
      end

      def read_pricing_info
        require 'pry'
        response = ApiCall.api_request("readPropertyPricingSetup", "PROP_ID": self.id)

        @currency = response.data["PRICING"]["CURRENCY"]

        per_guest_charge_info = response.data["PRICING"]["RENT"]["PERGUEST_CHARGE"]
        @per_guest_charge = PerGuestCharge.new(per_guest_charge_info["TYPE"],
                                               per_guest_charge_info["STANDARD"],
                                               per_guest_charge_info["MAX"])
        @fees = []
        response.data["PRICING"]["FEES"]["FEES"].each do |fee_info|

          if fee_info["VALUE"].is_a? Array
            fee_values = []
            fee_info["VALUE"].each do |fee_value_info|
              fee_values << FeeValue.new(fee_value_info["STAY_FROM"], fee_value_info["UNIT"], fee_value_info["VALUE"])
            end
          else
            fee_values = fee_info["VALUE"]
          end
            @fees << Fee.new(fee_info["FEE_TYPE_ID"], fee_info["INCLUDE_IN_RENT"], fee_info["UNIT"], fee_values)
        end

        @discounts = response.data["PRICING"]["DISCOUNTS"]

        @deposit = response.data["PRICING"]["DEPOSIT"]

        @periods = []
        response.data["PRICING"]["RENT"]["PERIODS"].each do |period_info|
          @periods << Period.new(period_info["CHECK_IN"],
                                 period_info["CHECK_OUT"],
                                 period_info["NAME"],
                                 period_info["STAY_MIN"],
                                 period_info["WEEKLY"],
                                 period_info["NIGHTLY_AMOUNTS"])
        end

      end

    end

  end
end
