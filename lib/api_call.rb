require 'typhoeus'
require 'yaml'

module KigoConnector

  class ApiCall

    BASE_OPTIONS = {
      method: :post,
      headers: {"Content-Type": "application/json"},
      ssl_verifypeer: false
    }

    Response = Struct.new(:raw, :data)

    def self.api_request(method, body, api_version = "1")

      end_point = select_end_point(method, api_version)

      raw = Typhoeus::Request.new("#{end_point}", BASE_OPTIONS.merge(body: body.to_json)).run
      raise ApiCallError.new(raw.body) if raw.response_code != 200 || JSON.parse(raw.body)["API_RESULT_CODE"] != "E_OK"

      data = JSON.parse(raw.body)["API_REPLY"]
      Response.new(raw, data)
    end

    private

    def self.select_end_point(method, api_version)
      case api_version
      when "1"
        credentials = YAML.load_file(".credentials.yml")["v1"]
        "https://#{credentials["user"]}:#{credentials["pass"]}@app.kigo.net/api/ra/v1/#{method}"
      when "2"
        credentials = YAML.load_file(".credentials.yml")["v2"]
        "https://www.kigoapis.com/channels/v1/#{method}?subscription-key=#{credentials["subscription_key"]}"
      else
        raise ApiCallError.new("Wrong API version.")
      end
    end

  end

  class ApiCallError < RuntimeError
  end

end
