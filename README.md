## EasyPost Example For Buying Shipments

The [EasyPost API](https://www.easypost.com/getting-started) provides an easy way to programatically create shipments and postage labels. This project provides an example for buying shipments using EasyPost API.

The application provides a minimal web application that can be hosted on any computer, and enables one to create a sample web application to buy shipments, create labels, and verify addresses using the EasyPost API.

### Requirements

1. A Windows or Mac computer running [Ruby](https://www.ruby-lang.org/en/) [Bundler](http://bundler.io/)
1. An [EasyPost account](https://www.easypost.com/signup)

### Running the Application

1. Check out this repo, `git clone https://github.com/EasyPost/example-ui-for-buying-shipments.git`
1. Move into the application's directory, `cd example-ui-for-buying-shipments`
1. Fill in the `.env` file
    1. `EAYSPOST_API_KEY` one of [your EasyPost Api Keys](https://www.easypost.com/account#/api-keys)
    1. `FROM_ADDRESS_ID` is the id of an [Address](https://www.easypost.com/docs/api.html#address-object) object that you are shipping from.
1. Install the dependencies, `bundle install --path vendor/bundle`
1. Run the server, `bundle exec rackup`
1. The application should be up and running at <http://localhost:9292/>

If you aren't seeing any labels, make sure you have bought some postage on EasyPost! You can walk through the [EasyPost Getting Started Guide](https://www.easypost.com/getting-started) using your test API Key.
