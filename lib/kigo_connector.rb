require "yaml"

module KigoConnector

  module V1
    credentials = YAML.load_file(".credentials.yml")["v1"]

    END_POINT = "https://#{credentials["user"]}:#{credentials["pass"]}@app.kigo.net/api/ra/v1/"

    BASE_OPTIONS = {
      method: :post,
      headers: {"Content-Type": "application/json"},
      ssl_verifypeer: false
    }

    def self.ping
      ApiCall.api_request("ping",'')
    end

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
