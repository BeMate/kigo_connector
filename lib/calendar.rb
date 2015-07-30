module KigoConnector

  class Calendar
    attr_reader :property, :reservation_id, :check_in, :check_out, :status, :owned

    def initialize(property_id, reservation_id, check_in, check_out, status, owned)
      @property = Property.new(property_id)
      @reservation_id = reservation_id
      @check_in = check_in
      @check_out = check_out
      @status = status
      @owned = owned
    end

    # TO-DO: We should return the diff_id provided by the Kigo API
    def self.list(diff_id)
      response = ApiCall.api_request("diffPropertyCalendarReservations", "DIFF_ID": diff_id)
      calendars = []
      response.data["RES_LIST"].each do |calendar_info|
        calendars << Calendar.new(
          calendar_info["PROP_ID"],
          calendar_info["RES_ID"],
          Date.parse(calendar_info["RES_CHECK_IN"]),
          Date.parse(calendar_info["RES_CHECK_OUT"]),
          calendar_info["RES_STATUS"],
          calendar_info["RES_IS_FOR"]
        )
      end
      calendars
    end

  end

end
