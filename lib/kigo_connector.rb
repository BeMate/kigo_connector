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

  end

end
