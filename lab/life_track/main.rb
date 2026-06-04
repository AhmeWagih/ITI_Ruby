# frozen_string_literal: true

require_relative 'event'
require_relative 'event_handler'
require_relative 'event_router'
require_relative 'console_handler'
require_relative 'file_handler'
require_relative 'html_handler'
require_relative 'cli'

##
# Main Application Entry Point
#
# This file orchestrates the entire application:
# 1. Creates an EventRouter (subject/observable)
# 2. Creates concrete handlers (strategies)
# 3. Registers handlers with the router
# 4. Starts the CLI interface
#
# Note: The CLI and Router know NOTHING about ConsoleHandler, FileHandler, or HTMLHandler.
# This ensures complete decoupling and adherence to Dependency Inversion.
#
def main
  puts "Initializing LifeTrack Application...\n"

  # Create the event router (Observer subject)
  router = EventRouter.new

  # Create concrete handler instances (Strategy implementations)
  console_handler = ConsoleHandler.new
  file_handler = FileHandler.new
  html_handler = HTMLHandler.new

  # Register all handlers with the router (Observer registration)
  router.register(console_handler)
  router.register(file_handler)
  router.register(html_handler)

  puts "✓ EventRouter initialized with #{router.handler_count} handlers"
  puts "  - ConsoleHandler (prints to console)"
  puts "  - FileHandler (logs to events.log)"
  puts "  - HTMLHandler (regenerates dashboard.html)"
  puts "  ✓ Router has ZERO knowledge of concrete handler types\n"

  # Start the CLI
  cli = CLI.new(router: router)
  cli.run
end

# Run the application
main if __FILE__ == $0
