# frozen_string_literal: true

require_relative 'event_handler'

##
# Console Handler (Concrete Strategy)
#
# Responsibility: Print event information to console
# SOLID Principle: Single Responsibility - console output only
#                  Liskov Substitution - interchangeable with other handlers
#
# This handler implements the strategy of writing events to standard output.
# It is one concrete implementation of the EventHandler interface and can be
# swapped with any other handler without affecting the router.
#
class ConsoleHandler < EventHandler
  ##
  # Prints event information to the console
  #
  # @param event [Event] The event to handle
  #
  def handle(event)
    puts "═" * 70
    puts "✓ Event Logged to Console"
    puts "─" * 70
    puts "Type:        #{event.type.upcase}"
    puts "Description: #{event.description}"
    puts "Duration:    #{event.duration_minutes} minutes"
    puts "Timestamp:   #{event.timestamp.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "═" * 70
  end
end
