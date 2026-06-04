# frozen_string_literal: true

require_relative 'event_handler'

##
# Slack Handler (Extensibility Example)
#
# DEMONSTRATION: This handler shows how to extend LifeTrack with a new
# notification strategy WITHOUT modifying EventRouter.
#
# Responsibility: Send event notifications to a Slack channel
# SOLID Principle: Single Responsibility - Slack integration only
#                  Liskov Substitution - interchangeable with other handlers
#
# To use this handler:
# 1. In main.rb, add: require_relative 'slack_handler'
# 2. Create instance: slack_handler = SlackHandler.new
# 3. Register: router.register(slack_handler)
# 4. Done! No EventRouter changes needed!
#
# This demonstrates perfect adherence to Open/Closed Principle:
# - EventRouter is CLOSED for modification
# - Application is OPEN for extension
#
class SlackHandler < EventHandler
  ##
  # Sends event notification to Slack (mock implementation)
  #
  # In production, this would:
  # - Connect to Slack API
  # - Use bot token for authentication
  # - Format message with event details
  # - Handle retries and errors
  #
  # @param event [Event] The event to handle
  #
  def handle(event)
    message = format_slack_message(event)
    send_to_slack(message)
  end

  private

  ##
  # Formats an event as a Slack message
  #
  # @param event [Event] The event to format
  # @return [String] formatted message
  #
  def format_slack_message(event)
    ":memo: *#{event.type.capitalize} Event Logged*\n" \
      "Description: #{event.description}\n" \
      "Duration: #{event.duration_minutes} minutes\n" \
      "Time: #{event.timestamp.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  ##
  # Sends message to Slack (mock)
  #
  # Production version would call Slack Webhook or API
  # For demo, just print the message
  #
  # @param message [String] The message to send
  #
  def send_to_slack(message)
    puts "✓ [Slack Notification]"
    puts message
    puts ""

    # Production implementation:
    # require 'net/http'
    # require 'json'
    #
    # webhook_url = ENV['SLACK_WEBHOOK_URL']
    # payload = { text: message, channel: '#lifetrack-events' }
    # http_post(webhook_url, payload)
  end
end
