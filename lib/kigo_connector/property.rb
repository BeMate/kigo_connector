module KigoConnector

  class Property
    attr_reader :id, :api_version, :info, :pricing, :fees, :discounts, :deposit, :currency, :per_guest_charge, :periods

    def initialize(id:, api_version: "1")
      if !id.nil?
        @id = id
        @api_version = api_version
      else
        raise PropertyException.new("ID is #{id.inspect}")
      end
    end

    def self.list(api_version: "1")
      response = ApiCall.api_request("listProperties2", nil, api_version)

      properties = []
      response.data.each do |property|
        properties << Property.new(id: property["PROP_ID"], api_version: api_version)
      end

      properties
    end

    def info
      @info ||= read_info
    end

    def pricing
      @rates ||= read_pricing_info
    end

    # checkin and checkout should be passed as a string YYYY-MM-DD
    def real_time_pricing_calculaton(check_in:, check_out:, guests:)
      response = ApiCall.api_request("computePricing",
                                     {"PROP_ID": self.id,
                                      "RES_CREATE":"#{Date.today}",
                                      "RES_CHECK_IN":"#{check_in}",
                                      "RES_CHECK_OUT":"#{check_out}",
                                      "RES_N_ADULTS": guests,
                                      "RES_N_CHILDREN": 0,
                                      "RES_N_BABIES": 0},
                                     api_version)

      response.data
    end

    %w(fees discounts deposit currency per_request_charge periods).each do |accessor|
      define_method accessor.to_sym do
        @rates ||= read_pricing_info
        instance_variable_get("@#{accessor}")
      end
    end

    private

    class Period
      attr_reader :check_in, :check_out, :name, :stay_min, :weekly, :nightly_amounts

      def initialize(check_in:, check_out:, name:, stay_min:, weekly:, nightly_amounts:)
        @check_in = Date.parse(check_in)
        @check_out = Date.parse(check_out)
        @name = name
        @stay_min = stay_min
        @weekly = weekly
        @nightly_amounts = nightly_amounts
      end
    end

    Fee = Struct.new(:type_id, :include_in_rent, :unit, :value)
    FeeValue = Struct.new(:stay_from, :unit, :value)
    PerGuestCharge = Struct.new(:type, :standard, :max)

    def read_info
      response = ApiCall.api_request("readProperty2", {"PROP_ID": self.id}, api_version)

      response.data["PROP_INFO"]
    end

    def read_pricing_info
      response = ApiCall.api_request("readPropertyPricingSetup", {"PROP_ID": self.id}, api_version)

      set_currency(response)
      set_per_guest_charge(response)
      set_fees(response)
      set_discounts(response)
      set_desposit(response)
      set_periods(response)
    end

    def set_currency(response)
      @currency = response.data["PRICING"]["CURRENCY"]
    end

    def set_per_guest_charge(response)
      per_guest_charge_info = response.data["PRICING"]["RENT"]["PERGUEST_CHARGE"]
      @per_guest_charge =
        per_guest_charge_info.nil? ? nil : PerGuestCharge.new(per_guest_charge_info["TYPE"],
                                                              per_guest_charge_info["STANDARD"],
                                                              per_guest_charge_info["MAX"])
    end

    def set_fees(response)
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
    end

    def set_discounts(response)
      @discounts = response.data["PRICING"]["DISCOUNTS"]
    end

    def set_desposit(response)
      @deposit = response.data["PRICING"]["DEPOSIT"]
    end

    def set_periods(response)
      @periods = []
      response.data["PRICING"]["RENT"]["PERIODS"].each do |period_info|
        @periods << Period.new(check_in: period_info["CHECK_IN"],
                               check_out: period_info["CHECK_OUT"],
                               name: period_info["NAME"],
                               stay_min: period_info["STAY_MIN"],
                               weekly: period_info["WEEKLY"],
                               nightly_amounts:period_info["NIGHTLY_AMOUNTS"])
      end

    end

  end

end
