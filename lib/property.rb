module KigoConnector
  module V1

    class Property
      attr_reader :id

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

      def rate
        @rate ||= read_rate
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


      private

      def read_info
        response = ApiCall.api_request("readProperty2", "PROP_ID": id)
        response.data["PROP_INFO"]
      end

    end

  end
end
