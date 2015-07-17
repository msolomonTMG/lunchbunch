require 'hipbot'
require 'hipbot-plugins/human'
require 'factual'
require 'sinatra'
require 'sinatra-logentries'

# require 'hipbot-plugins/github'
# require 'hipbot-plugins/google'
# check out more plugins on https://github.com/netguru/hipbot-plugins
set :environment, :production

configure do
  Sinatra::Logentries.token = ENV['SINATRA_LOGENTRIES_TOKEN']
end

FACTUAL = Factual.new(ENV['FACTUAL_API_KEY'], ENV['FACTUAL_API_SECRET'])

logger.info("Informational Message")

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
    #reply ('hows this')
    data = get_recommendation
    name = data["name"]
    reply ('I cant answer')
  end

  def get_recommendation
    #random = Random.rand(0...10)
    random = 0
    data = FACTUAL.table("places-us").search("coffee").geo("$circle" => {"$center" => [40.7242800, -73.9973540], "$meters" => 500}).include_count(true).rows 
    logger.info(data[random]["name"])
    return data[random]
  end

end

$stdout.sync = true

MyHipbot.start!