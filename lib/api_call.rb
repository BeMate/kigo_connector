module KigoConnector

  module V1

    class ApiCall
      Response = Struct.new(:raw, :data)

      def self.api_request(method, body)
        raw = Typhoeus::Request.new("#{END_POINT}#{method}",
                                    BASE_OPTIONS.merge(body: body.to_json)).run

        data = JSON.parse(raw.body)["API_REPLY"]

        Response.new(raw, data)
      end

    end

  end

end
