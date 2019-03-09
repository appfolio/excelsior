class SlackSender

  def initialize(message)
    @message = message
  end

  def send_slack_message
    return unless @message.is_a?(Appreciation) # TODO ask some other class if it's ok to send this message
    service = ENV['SLACK_URL']
    slack_channel = ENV['SLACK_CHANNEL']

    payload = {
        "username" => "Excelsior!",
        "text" => <<-TEXT
*#{@message.anonymous? ? 'Someone anonymous' : @message.submitter.name}* appreciates *#{@message.recipient.name}*:
#{@message.message}
*#{signoff}*
TEXT
      }

    payload.merge!("channel" => slack_channel)

    response = HTTParty.post(service, {
      :body => payload.to_json,
      :headers => { "Content-Type" => "application/json",
                    "Accept" => "application/json" }
    })

    response
  end

  private

  def signoff
    ["BOOM. :boom:", "HEY-O!", "Yippee!", "Good times. :party:", "Say what!?", "Right on. :punch:", "Wup wup!", "Good golly!", "Meow :kitty:", "Cheerio!", "Holy Gaboly!",
     "Cowabunga!", "Heavens to Betsy! :scream:", "Hooray!", "Zoinks!", "Merry Christmas! :santa::skin-tone-2:", "YEEP", "Voila.", "snazzy :unicorn:", "schwag :gem:",
     "Bingo bango", "Let's hang out after work!", "Will you accept this rose? :rose:", "Booyakasha!",
     "Hungry for Apples? :apple:", "Wubba Lubba Dub Dub! :tinyrick:"].shuffle.first
  end
end
