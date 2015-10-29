Gem::Specification.new do |s|
    s.name        = 'exchange_rate'
    s.version     = '1.1.7'
    s.date        = '2015-10-25'
    s.summary     = "Exchange Rate Library"
    s.description = "A simple gem for finding exchange rates on certain dates"
    s.authors     = ["Evangelia Koleli"]
    s.email       = 'evakoleli@gmail.com'
    s.files       = ["lib/exchange_rate.rb"]
    s.license     = 'MIT'

    s.add_dependency 'nokogiri', '~> 1.6'
    s.add_dependency 'rspec', '~> 3.3'
end
