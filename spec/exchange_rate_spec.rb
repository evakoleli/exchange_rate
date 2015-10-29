require 'spec_helper'
require 'nokogiri'

describe ExchangeRate do
  describe 'init' do
    it 'make sure instance variable rates gets initialized' do
      ExchangeRate.init('./spec/support/test_euro_rate.xml')
      expect(ExchangeRate.instance_variable_get(:@rates)).not_to be_nil 
    end

    it 'make sure instance variable currencies contains the right data' do
      ExchangeRate.init('./spec/support/test_euro_rate.xml')
      expect(ExchangeRate.get_currencies).to include('EUR')
      expect(ExchangeRate.get_currencies).to include('GBP')
      expect(ExchangeRate.get_currencies).to include('USD')
      expect(ExchangeRate.get_currencies).to include('DKK')
      expect(ExchangeRate.get_currencies).not_to include('HUF')
    end
  end

  describe 'at' do
    before do
      rates = Nokogiri::XML(File.open('./spec/support/test_euro_rate.xml'))
      rates.remove_namespaces!
      ExchangeRate.instance_variable_set(:@rates, rates) 
      ExchangeRate.instance_variable_set(:@currencies, ['EUR', 'USD', 'GBP']) 
    end

    it 'a date in range' do
      date = Date.parse('2015-10-14')
      expect(ExchangeRate.at(date, 'EUR', 'USD')).to eq(1.141)
    end

    it 'Sunday\s rate should be equal to Friday\s' do
      sunday = Date.parse('2015-10-11')
      friday = Date.parse('2015-10-09')
      expect(ExchangeRate.at(sunday, 'EUR', 'USD')).to eq(ExchangeRate.at(friday, 'EUR', 'USD'))
    end

    it 'a date out of range' do
      date = Date.parse('2015-09-14')
      expect(ExchangeRate.at(date, 'EUR', 'USD')).to eq(0)
    end
  end

  describe 'get_currencies' do
    before do
      ExchangeRate.instance_variable_set(:@currencies, ['EUR', 'USD', 'GBP']) 
    end

    it 'returns the instance variable @currencies' do
      expect(ExchangeRate.get_currencies).to include('EUR')
      expect(ExchangeRate.get_currencies).to include('GBP')
      expect(ExchangeRate.get_currencies).to include('USD')
      expect(ExchangeRate.get_currencies).not_to include('DKK')
    end
  end
end
