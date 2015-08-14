module KigoConnector

  class Calendar
    attr_reader :property, :reservation_id, :check_in, :check_out, :status, :owned

    def initialize(property_id:, reservation_id:, check_in:, check_out:, status:, owned:)
      @property = Property.new(id: property_id)
      @reservation_id = reservation_id
      @check_in = check_in
      @check_out = check_out
      @status = status
      @owned = owned
    end

    # TO-DO: We should return the diff_id provided by the Kigo API
    def self.list(diff_id = nil)
      response = ApiCall.api_request("diffPropertyCalendarReservations", "DIFF_ID": diff_id)
      calendars = []
      response.data["RES_LIST"].each do |calendar_info|
        calendars << Calendar.new(
          property_id: calendar_info["PROP_ID"],
          reservation_id: calendar_info["RES_ID"],
          check_in: Date.parse(calendar_info["RES_CHECK_IN"]),
          check_out: Date.parse(calendar_info["RES_CHECK_OUT"]),
          status: calendar_info["RES_STATUS"],
          owned: calendar_info["RES_IS_FOR"]
        )
      end
      calendars
    end

  end

end
