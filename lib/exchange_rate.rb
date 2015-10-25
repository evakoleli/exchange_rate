require 'nokogiri'

class ExchangeRate

  # load variables with exchange rates and available currencies
  # Args: f - the XML file path
  def self.init(f)
    @rates = Nokogiri::XML(File.open(f))
    @rates.remove_namespaces!
    @currencies = ['EUR'] + self.load_currency_table
  end

  # returns exchange rate of given currencies on given 
  # date or 0 if args are not valid
  #
  # Args:          date - the date of the exchange
  #      from_currency - from given currency
  #        to_currency - to given currency
  def self.at(date, from_currency, to_currency)
    return 0 unless self.valid_args?(from_currency, to_currency)

    # if given date not in range of 90-days
    date = self.valid_date(date)
    return 0 unless date

    rates = @rates.xpath("//Cube//Cube[@time='#{date.to_s}']")
    from_rate = (from_currency == 'EUR' ? 1 : rates.xpath("./*[@currency='#{from_currency}']").first.attribute('rate').value).to_f
    to_rate = (to_currency == 'EUR'? 1 : rates.xpath("./*[@currency='#{to_currency}']").first.attribute('rate').value).to_f
    to_rate/from_rate
  end 

  # returns currencies variable
  def self.get_currencies
    @currencies
  end

  private

  # returns an array of all the available currencies
  def self.load_currency_table
    currencies = []
    currency_entries = @rates.xpath("//*[@currency]")
    currency_entries .each do |cur|
      currency = cur.attribute('currency').to_s
      currencies << currency unless currencies.include? currency
    end
    currencies
  end
  
  # returns true if args are valid and false otherwise
  def self.valid_args?(from_currency, to_currency)
    # if init has not been called
    return false if @rates.nil? or @currencies.nil?

    # if given currencies not included in the currencies array
    return false if !@currencies.include?(from_currency) or !@currencies.include?(to_currency)
    true
  end

  # returns the right date if given date in date range, or nil if not
  def self.valid_date(date)
    if date.saturday? or date.sunday?
      self.valid_date(date.prev_day)
    else
      unless @rates.xpath("//Cube//Cube[@time='#{date.to_s}']").empty?
        return date
      else
        return nil
      end
    end
  end
end
