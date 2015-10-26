# Exchange Rate Gem

This is a gem for calculating exchange rates on a certain date.

## Data Source

This gem is developed based on the [90 day European Central Bank (ECB) feed](http://www.ecb.europa.eu/stats/eurofxref/eurofxrefhist90d.xml).

## Usage

First, load the .xml file that contains the exchange rates:

`> ExchangeRate.init("./eurorate.xml")`

Then, you can use the "at" method in order to calculate the rate on a certain date:

e.g. `ExchangeRate.at(date, from_currency, to_currency)`

`> ExchangeRate.at(Date.parse('2015-10-22'), 'GBP', 'USD')` 

`=> 1.5467596390484002`

You can also get an array with every available currency on the .xml file:

`> ExchangeRate..get_currencies`

` => ["EUR", "USD", "JPY", "BGN", "CZK", ... , "DKK", "GBP"]`
