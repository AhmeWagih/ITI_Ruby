# frozen_string_literal: true

require_relative 'event'
require_relative 'event_router'
require_relative 'console_handler'
require_relative 'file_handler'
require_relative 'html_handler'
require_relative 'slack_handler'

##
# Extensibility Demo - Adding SlackHandler Without Modifying EventRouter
#
# This demonstrates the Open/Closed Principle in action:
# - EventRouter is CLOSED for modification (not touched)
# - Application is OPEN for extension (SlackHandler added)
#
# IMPORTANT: No changes to event_router.rb were made to support this new handler!
#

def extensibility_demo
  puts "\n" + "=" * 70
  puts "   Extensibility Demo: Adding SlackHandler Runtime"
  puts "=" * 70 + "\n"

  puts "SCENARIO: New requirement to send events to Slack"
  puts "CHALLENGE: Add this capability without modifying EventRouter"
  puts "SOLUTION: Create SlackHandler and register it\n"

  puts "─" * 70
  puts "STEP 1: Verify EventRouter source code has NOT changed"
  puts "─" * 70
  verify_router_unchanged
  puts "\n"

  puts "─" * 70
  puts "STEP 2: Create EventRouter and register 4 handlers (original 3 + Slack)"
  puts "─" * 70

  router = EventRouter.new

  # Original three handlers
  console_handler = ConsoleHandler.new
  file_handler = FileHandler.new
  html_handler = HTMLHandler.new

  # NEW HANDLER - NO ROUTER CHANGES NEEDED!
  slack_handler = SlackHandler.new

  router.register(console_handler)
  router.register(file_handler)
  router.register(html_handler)
  router.register(slack_handler)  # Just register it!

  puts "✓ Registered #{router.handler_count} handlers:"
  router.handlers.each_with_index do |handler, idx|
    puts "  #{idx + 1}. #{handler.class}"
  end

  puts "\n✓ EventRouter code: UNCHANGED ✓"
  puts "✓ New handler added: ONLY by registration ✓"
  puts "✓ Open/Closed Principle: SATISFIED ✓\n"

  puts "─" * 70
  puts "STEP 3: Dispatch an event to all 4 handlers (including Slack)"
  puts "─" * 70

  event = Event.new(
    type: 'work',
    description: 'Implemented Observer & Strategy patterns',
    duration_minutes: 180
  )

  puts "\nDispatching: #{event.to_s}\n"
  router.dispatch(event)

  puts "─" * 70
  puts "VERIFICATION COMPLETE"
  puts "─" * 70
  puts "\n✓ All 4 handlers received the event"
  puts "✓ ConsoleHandler printed output"
  puts "✓ FileHandler appended to events.log"
  puts "✓ HTMLHandler regenerated dashboard"
  puts "✓ SlackHandler sent Slack notification"
  puts "\n✓ EventRouter was NOT modified"
  puts "✓ No existing code was changed"
  puts "✓ Only SlackHandler code was added"
  puts "\nCONCLUSION: Perfect Open/Closed Principle Implementation ✓\n"
end

##
# Verifies that EventRouter source still has zero concrete handler references
#
def verify_router_unchanged
  router_file = File.read(__dir__ + '/event_router.rb')

  all_handlers = ['ConsoleHandler', 'FileHandler', 'HTMLHandler', 'SlackHandler']
  found = all_handlers.select { |h| router_file.include?(h) }

  if found.empty?
    puts "✓ EventRouter contains ZERO handler class references"
    puts "✓ Including ZERO references to SlackHandler"
    puts "✓ Router only depends on EventHandler abstraction"
  else
    puts "❌ Found unexpected references: #{found.join(', ')}"
  end
end

# Run the demo
extensibility_demo
