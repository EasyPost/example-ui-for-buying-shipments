# example-buy-shipment-ui

## EasyPost Buy Shipment Example

The [EasyPost API](https://www.easypost.com/getting-started) provides an easy
way to programatically create shipments and postage labels. 
This project provides an example for buying shipments using EasyPost API.

The application provides a minimal web application that can be hosted on any
computer, and enables one to buy shipments and receive labels along a tracking number.

### Requirements

1. A Windows or Mac computer running [Ruby](https://www.ruby-lang.org/en/)
   [Bundler](http://bundler.io/)  
1. An [EasyPost account](https://www.easypost.com/signup)

### Running the Application

1. Check out this repo and `cd` into the project directory
1. Copy or rename the sample.env to .env, and fill in values for
    1. [your EasyPost Api Key](https://www.easypost.com/account#/api-keys)
1. Run `bundle install`
1. Run `rackup`
1. The application should be up and running at <http://localhost:9292/>

If you aren't seeing any labels, make sure you have bought some postage on
EasyPost! You can walk through the
[EasyPost Getting Started Guide](https://www.easypost.com/getting-started) using
your test API Key and you won't be charged.


