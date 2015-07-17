require 'hipbot'
require 'hipbot-plugins/human'
require 'factual'
# require 'hipbot-plugins/github'
# require 'hipbot-plugins/google'
# check out more plugins on https://github.com/netguru/hipbot-plugins

factual = Factual.new(ENV['FACTUAL_API_KEY'], ENV['FACTUAL_API_SECRET'])

class MyHipbot < Hipbot::Bot
  configure do |c|
    c.jid       = ENV['HIPBOT_JID']
    c.password  = ENV['HIPBOT_PASSWORD']
    fail "Define HIPBOT_JID and HIPBOT_PASSWORD env variables!" unless c.jid && c.password
  end

  desc 'this is a simple response'
  on(/hello hipbot/) do
    reply('hello human')
  end

  desc 'this is a response with arguments'
  on(/my name is (\w+) (\w+)/) do |first_name, last_name|
    reply("nice to meet you, #{first_name} #{last_name}!")
  end

  desc 'lunch'
  on(/(lunchbunch)/) do
    reply ('hows this' ENV['FACTUAL_API_SECRET'])
    data = factual.table("places-us").search("coffee").geo("$circle" => {"$center" => [40.7242800, -73.9973540], "$meters" => 500}).rows 
    reply (data)
  end

end

$stdout.sync = true

MyHipbot.start!