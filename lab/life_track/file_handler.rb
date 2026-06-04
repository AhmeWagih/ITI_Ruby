# frozen_string_literal: true

require_relative 'event_handler'

##
# File Handler (Concrete Strategy)
#
# Responsibility: Append event information to a log file
# SOLID Principle: Single Responsibility - file persistence only
#                  Liskov Substitution - interchangeable with other handlers
#
# This handler implements the strategy of writing events to a file (events.log).
# It appends a JSON representation of each event, enabling log analysis and
# audit trails. Each call creates a new line in the log.
#
class FileHandler < EventHandler
  LOG_FILE = 'events.log'

  ##
  # Appends event information to events.log in JSON format
  #
  # @param event [Event] The event to handle
  #
  def handle(event)
    File.open(LOG_FILE, 'a') do |file|
      file.puts event_to_json(event)
    end
    puts "✓ Event appended to #{LOG_FILE}"
  end

  private

  ##
  # Converts an event to JSON format for logging
  #
  # @param event [Event] The event to convert
  # @return [String] JSON representation of the event
  #
  def event_to_json(event)
    require 'json'
    JSON.generate(event.to_h)
  end
end
