# frozen_string_literal: true

require_relative 'event'
require_relative 'event_router'
require_relative 'console_handler'
require_relative 'file_handler'
require_relative 'html_handler'

##
# Demo Script - Automated Test Run
#
# This script demonstrates the LifeTrack application without user interaction.
# It creates sample events and verifies that all handlers receive and process them.
# This is useful for:
# - Testing the architecture
# - Verifying the Observer pattern works correctly
# - Validating that the router contains zero concrete handler names
# - Demonstrating extensibility
#

def demo
  puts "\n" + "=" * 70
  puts "   LifeTrack CLI - Automated Demo & Architecture Verification"
  puts "=" * 70 + "\n"

  # Step 1: Verify EventRouter source code
  puts "STEP 1: Verifying EventRouter Implementation"
  puts "─" * 70
  verify_router_code
  puts "\n"

  # Step 2: Create router and handlers
  puts "STEP 2: Initializing Architecture"
  puts "─" * 70
  router = EventRouter.new
  console_handler = ConsoleHandler.new
  file_handler = FileHandler.new
  html_handler = HTMLHandler.new

  router.register(console_handler)
  router.register(file_handler)
  router.register(html_handler)

  puts "✓ EventRouter created and configured"
  puts "✓ #{router.handler_count} handlers registered"
  puts "✓ Router knows about handlers: #{router.handlers.map(&:class).join(', ')}\n"

  # Step 3: Create and dispatch sample events
  puts "\nSTEP 3: Dispatching Sample Events Through Observer Pattern"
  puts "─" * 70

  sample_events = [
    Event.new(type: 'work', description: 'Completed project architecture', duration_minutes: 120),
    Event.new(type: 'study', description: 'Reviewed SOLID principles', duration_minutes: 90),
    Event.new(type: 'exercise', description: 'Morning run', duration_minutes: 45),
    Event.new(type: 'meal', description: 'Lunch break', duration_minutes: 30)
  ]

  sample_events.each do |event|
    puts "\n>>> Dispatching event: #{event.to_s}"
    router.dispatch(event)
  end

  puts "\n"

  # Step 4: Verify file persistence
  puts "STEP 4: Verifying File Persistence (Strategy Pattern)"
  puts "─" * 70
  if File.exist?('events.log')
    puts "✓ events.log exists"
    lines = File.readlines('events.log').length
    puts "✓ File contains #{lines} event lines\n"
  end

  if File.exist?('dashboard.html')
    puts "✓ dashboard.html exists"
    size = File.size('dashboard.html')
    puts "✓ File size: #{size} bytes\n"
  end

  # Step 5: Show event log
  puts "\nSTEP 5: Event Log Contents"
  puts "─" * 70
  if File.exist?('events.log')
    require 'json'
    File.readlines('events.log').each_with_index do |line, index|
      event_data = JSON.parse(line, symbolize_names: true)
      puts "#{index + 1}. #{event_data[:type]} - #{event_data[:description]} (#{event_data[:duration_minutes]} min)"
    end
  end

  puts "\n"
end

##
# Verifies that EventRouter contains zero concrete handler class names
#
def verify_router_code
  router_file = File.read(__dir__ + '/event_router.rb')

  handlers = ['ConsoleHandler', 'FileHandler', 'HTMLHandler']
  found_references = []

  handlers.each do |handler|
    if router_file.include?(handler)
      found_references << handler
    end
  end

  if found_references.empty?
    puts "✓ EventRouter contains ZERO concrete handler class references"
    puts "✓ EventRouter depends only on EventHandler abstraction"
    puts "✓ Open/Closed Principle satisfied: adding handlers requires no router changes"
  else
    puts "❌ FAILED: Found references to: #{found_references.join(', ')}"
  end
end

# Run the demo
demo
