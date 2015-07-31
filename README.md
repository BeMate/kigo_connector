## Kigo Connector (WIP)

Kigo API wrapper.

## General philosophy

The goal is to provide an object oriented wrapper over the Kigo API[^1] so a client, should be able to retrieve any
information from this channel manager using business domain objects
like Property, Calendar, etc.

By default, all the low level stuff like the underneath http requests
should be transparent for the clients using KigoConnector.

All calls to the API are lazy, meaning that they will be fired only
when it's strictly necessary, and they are memomized for the entire
life of the object/s holding the data.

## Usage

1. Provide account credentials on .credentials.yml (see
crendetials.example.yml for an example).

2.

### Accessing Property information

Instantiate a Property using its ID:

```
$ property = KigoConnector::Property.new(1234)
=> #<KigoConnector::Property:0x007f803fc7afa8 @api_version="1", @id=1234>
```
Now you can access info, pricing, fees, discounts, deposit,
currency, per_guest_charge and periods

```
$ property.info
=> {"PROP_NAME"=>"Very nice place",
 "PROP_STREETNO"=>"34",
 "PROP_ADDR1"=>"Calle No Existente",
 "PROP_ADDR2"=>"",
 "PROP_ADDR3"=>"",
 "PROP_APTNO"=>"2º3ª",
 "PROP_POSTCODE"=>"08021",
 "PROP_CITY"=>"Barcelona",
 "PROP_REGION"=>"Sant Gervasi",
 "PROP_COUNTRY"=>"ES",
 "PROP_PHONE"=>"",
 "PROP_AXSCODE"=>"",
 "PROP_BEDROOMS"=>3,
 "PROP_BEDS"=>5,
 "PROP_BED_TYPES"=>[3, 4, 4, 4, 4],
 "PROP_BATHROOMS"=>2,
 "PROP_TOILETS"=>0,
 "PROP_TYPE_ID"=>14,
 "PROP_SIZE"=>100,
 "PROP_SIZE_UNIT"=>"SQMETER",
 "PROP_MAXGUESTS"=>6,
 "PROP_MAXGUESTS_ADULTS"=>6,
 [...]

$ property.fees
=> [#<struct KigoConnector::Property::Fee type_id=3, include_in_rent=false, unit="AMOUNT", value="90.00">,
 #<struct KigoConnector::Property::Fee
  type_id=10,
  include_in_rent=false,
  unit="STAYLENGTH",
  value=
   [#<struct KigoConnector::Property::FeeValue
     stay_from={"UNIT"=>"NIGHT", "NUMBER"=>1},
     unit="AMOUNT_PER_NIGHT_PER_GUEST",
     value={"AMOUNT_ADULT"=>"0.72", "AMOUNT_CHILD"=>"0.72", "AMOUNT_BABY"=>"0.00"}>,
    #<struct KigoConnector::Property::FeeValue
     stay_from={"UNIT"=>"NIGHT", "NUMBER"=>8},
     unit="AMOUNT_PER_GUEST",
     value={"AMOUNT_ADULT"=>"5.04", "AMOUNT_CHILD"=>"5.04", "AMOUNT_BABY"=>"0.00"}>]>]
```

You can also retrieve a list a of all properties associated to your
account by doing:

`Property.list`

### Accessing availability information

You could access the availability information by calling
`Calendar.list`. That will return all the availability information
related to your Kigo account as instances of Calendar.

That will also instantiate the property associated with it so you could
access it directly:

```
$ calendar = Calendar.list.first
=> #<KigoConnector::Calendar:0x007f9cd1f490f0
 @check_in=#<Date: 2014-10-01 ((2456932j,0s,0n),+0s,2299161j)>,
 @check_out=#<Date: 2015-05-31 ((2457174j,0s,0n),+0s,2299161j)>,
 @owned=false,
 @property=#<KigoConnector::Property:0x007f9cd1f490c8 @api_version="1", @id=31002>,
 @reservation_id=1082203,
 @status="CONFIRMED">

$ calendar.property.info
=>{"PROP_NAME"=>"Very nice place",
 "PROP_STREETNO"=>"34",
 "PROP_ADDR1"=>"Calle No Existente",
 "PROP_ADDR2"=>"",
 "PROP_ADDR3"=>"",
 "PROP_APTNO"=>"2º3ª",
 "PROP_POSTCODE"=>"08021",
 "PROP_CITY"=>"Barcelona",
 "PROP_REGION"=>"Sant Gervasi",
 "PROP_COUNTRY"=>"ES",
 "PROP_PHONE"=>"",
 "PROP_AXSCODE"=>"",
 "PROP_BEDROOMS"=>3,
 "PROP_BEDS"=>5,
 "PROP_BED_TYPES"=>[3, 4, 4, 4, 4],
 "PROP_BATHROOMS"=>2,
 "PROP_TOILETS"=>0,
 "PROP_TYPE_ID"=>14,
 "PROP_SIZE"=>100,
 "PROP_SIZE_UNIT"=>"SQMETER",
 "PROP_MAXGUESTS"=>6,
 "PROP_MAXGUESTS_ADULTS"=>6,
 [...]
```

*You can (and most of the time you should) also pass a Diff ID as a
parameter to `calendar.list`*

See the corresponding explanation on how to retrieve and use
Diff IDs on the Kigo API documentation.
You can not ask the Kigo API for availability information based on a
Property

### Kigo API versions

It turns out, right now, Kigo has two different APIs living in
production at the same time. The thing is, that those APIs (apart from
the usual method deprecation, data format changes, etc) hold different
datasets.

So depending on your account you may find yourself having to query
properties on two different endpoints.

This library tries to make this process as transparent as possible:

* Uses the same business objects no matter the API version.
* When querying for Properties or Calendars, you have the option to
provide a string representing the API version (1 or 2).
* By default, all queries go to the version 1.

This situation should be temporary as both API's versions (and their
associated datasets) should become one.

When this happens, all code to provide an API version will be remove,
but all the client code using the default signatures (not providing
any API version) will work without changes on the client side.

### Dealing with errors

When the Kigo API returns a status code other than 200, this
library will raise an ApiCallError (child of RuntimeError).

When the Kigo API returns a request body with a code other than E_OK, this
library will raise an ApiCallError (child of RuntimeError).

ApiCallError will print the response body to ease the debugging
process if necessary.

**Clients using this library must deal with this.**


## TODO

- ~~Change test suit so it uses RSpec.~~
- ~~Handle errors on API calls (bad request, empty response, etc)~~
- We must return somehow the diff ids when the Kigo API provide us
with it.
- Test based on VCR are nice but:
- Fixtures are unreadable (body is encrypted).
- Doesn't prevent to miserably fail on production if the API
response change.
- Make this library a gem.

[^1]: http://kigo.net
