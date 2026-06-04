# frozen_string_literal: true

require_relative 'event'
require_relative 'event_router'

##
# CLI Interface
#
# Responsibility: Display menu, collect user input, create events, dispatch to router
# SOLID Principle: Single Responsibility - user interaction only
#                  Dependency Inversion - depends on EventRouter abstraction
#
# This class provides the user interface. It never directly calls any handler;
# it only communicates with EventRouter. This ensures CLI is decoupled from
# specific handler implementations and can be tested independently.
#
class CLI
  EVENT_TYPES = %w[work study exercise meal].freeze

  ##
  # Initialize CLI with a router
  #
  # @param router [EventRouter] The event router to dispatch events to
  #
  def initialize(router:)
    @router = router
  end

  ##
  # Starts the interactive CLI loop
  #
  def run
    puts "\n" + "═" * 70
    puts "   Welcome to LifeTrack - Event Logging Application"
    puts "═" * 70 + "\n"

    loop do
      display_menu
      choice = get_user_choice

      case choice
      when 1
        create_and_log_event
      when 2
        show_statistics
      when 3
        puts "\n✓ Thank you for using LifeTrack. Goodbye!\n"
        break
      else
        puts "❌ Invalid choice. Please try again.\n"
      end
    end
  end

  private

  ##
  # Displays the main menu
  #
  def display_menu
    puts "\n" + "─" * 70
    puts "MENU"
    puts "─" * 70
    puts "1. Log a new event"
    puts "2. View statistics"
    puts "3. Exit"
    puts "─" * 70
    print "Enter your choice (1-3): "
  end

  ##
  # Gets and validates user's menu choice
  #
  # @return [Integer] user's choice
  #
  def get_user_choice
    gets.chomp.to_i
  rescue StandardError
    0
  end

  ##
  # Guides user through creating and logging an event
  #
  def create_and_log_event
    puts "\n" + "─" * 70
    puts "LOG A NEW EVENT"
    puts "─" * 70

    event_type = select_event_type
    return if event_type.nil?

    description = get_event_description
    return if description.nil?

    duration = get_event_duration
    return if duration.nil?

    begin
      event = Event.new(
        type: event_type,
        description: description,
        duration_minutes: duration
      )

      @router.dispatch(event)

      puts "\n✓ Event successfully logged and distributed to all handlers!\n"
    rescue ArgumentError => e
      puts "\n❌ Error creating event: #{e.message}\n"
    end
  end

  ##
  # Displays a menu for selecting event type
  #
  # @return [String, nil] selected event type or nil if cancelled
  #
  def select_event_type
    puts "\nSelect event type:"
    EVENT_TYPES.each_with_index do |type, index|
      puts "#{index + 1}. #{type.capitalize}"
    end
    print "Enter choice (1-#{EVENT_TYPES.length}): "

    choice = gets.chomp.to_i
    return nil if choice < 1 || choice > EVENT_TYPES.length

    EVENT_TYPES[choice - 1]
  end

  ##
  # Gets event description from user
  #
  # @return [String, nil] description or nil if empty
  #
  def get_event_description
    print "\nEnter event description: "
    description = gets.chomp.strip
    return nil if description.empty?

    description
  end

  ##
  # Gets event duration from user with validation
  #
  # @return [Integer, nil] duration in minutes or nil if invalid
  #
  def get_event_duration
    print "Enter duration in minutes (positive integer): "
    duration = gets.chomp.to_i
    return nil if duration <= 0

    duration
  rescue StandardError
    nil
  end

  ##
  # Displays statistics from the log file
  #
  def show_statistics
    return unless File.exist?('events.log')

    puts "\n" + "─" * 70
    puts "📊 EVENT STATISTICS"
    puts "─" * 70

    require 'json'

    events = File.readlines('events.log').map { |line| JSON.parse(line, symbolize_names: true) }
    return if events.empty?

    total_events = events.size
    total_minutes = events.sum { |e| e[:duration_minutes].to_i }
    avg_duration = (total_minutes / total_events).round(1)

    type_stats = events.group_by { |e| e[:type] }
                       .transform_values { |evts| [evts.size, evts.sum { |e| e[:duration_minutes].to_i }] }

    puts "Total Events: #{total_events}"
    puts "Total Time: #{total_minutes} minutes"
    puts "Average Duration: #{avg_duration} minutes\n"

    puts "Breakdown by Type:"
    type_stats.each do |type, (count, minutes)|
      puts "  - #{type.capitalize}: #{count} events, #{minutes} minutes"
    end

    puts "─" * 70 + "\n"
  end
end
