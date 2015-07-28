## Kigo Connector

Kigo API wrapper.

## WIP

## TODO

- Change test suit so it uses RSpec.
- Handle errors on API calls (bad request, empty response, etc)
- We must return somehow the diff ids when the Kigo API provide us
  with it.
  - Test based on VCR are nice but:
    - Fixtures are unreadable (body is encrypted).
    - Doesn't prevent to miserably fail on production if the API
      response change.
