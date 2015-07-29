## Kigo Connector (WIP)

Kigo API wrapper.

## General philosophy

is to provide an OO wrapper over the Kigo API[^1] so whenever
possible, using this library, you should be able to retrieve any
information from this channel manager using bussiness domain objects
like Property, Calendar, etc.

By default, all the low level stuff like the underneeth http request
should be tranparent for the clients using KigoConnector.

All calls to the API are lazy, meaning that they will be fired only
when it's strictly necessary, and they're memomized for the entire
life of the objetc/s holding the data.

## Usage

Provide account credentials on .credentials.yml (see
crendetials.example.yml for an example).

### Accesing Property information

Instantiate a Property using its ID:

```
property = Property.new
```
Now you can access info, pricing, fees, discounts, deposit,
currency, per_guest_charge and periods

```
property.info
#=>
property.prices
#=>
```

You can also retrieve a list a of all properties associated to your
account by doing:

`Property.list`

### Accesing availavility information

### Dealing with errors


## TODO

- ~~Change test suit so it uses RSpec.~~
- Handle errors on API calls (bad request, empty response, etc)
- We must return somehow the diff ids when the Kigo API provide us
  with it.
- Test based on VCR are nice but:
  - Fixtures are unreadable (body is encrypted).
  - Doesn't prevent to miserably fail on production if the API
    response change.

[^1]: http://kigo.net
