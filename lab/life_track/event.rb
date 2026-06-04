# frozen_string_literal: true

##
# Event Data Object
#
# Responsibility: Hold event data only (type, description, duration, timestamp)
# SOLID Principle: Single Responsibility - data storage only, no logic or side effects
#
# This class is a simple data transfer object that carries event information
# through the application without performing any operations. It is immutable
# to prevent accidental modifications during transit.
#
class Event
  # Event types
  VALID_TYPES = %w[work study exercise meal].freeze

  attr_reader :type, :description, :duration_minutes, :timestamp

  ##
  # Creates a new Event instance
  #
  # @param type [String] Event type (work, study, exercise, or meal)
  # @param description [String] Human-readable event description
  # @param duration_minutes [Integer] Event duration in minutes
  # @param timestamp [Time] When the event occurred (defaults to now)
  #
  # @raise [ArgumentError] if type is invalid or duration is negative
  #
  def initialize(type:, description:, duration_minutes:, timestamp: Time.now)
    validate_type!(type)
    validate_duration!(duration_minutes)

    @type = type
    @description = description
    @duration_minutes = duration_minutes
    @timestamp = timestamp
  end

  ##
  # Returns a hash representation of the event
  #
  # @return [Hash] event data as a hash
  #
  def to_h
    {
      type: @type,
      description: @description,
      duration_minutes: @duration_minutes,
      timestamp: @timestamp
    }
  end

  ##
  # Returns a formatted string representation of the event
  #
  # @return [String] human-readable event summary
  #
  def to_s
    "#{@type.upcase}: #{@description} (#{@duration_minutes} min) at #{@timestamp.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  private

  ##
  # Validates that the event type is in the list of allowed types
  #
  # @param type [String] type to validate
  # @raise [ArgumentError] if type is invalid
  #
  def validate_type!(type)
    raise ArgumentError, "Invalid type: #{type}. Must be one of: #{VALID_TYPES.join(', ')}" unless VALID_TYPES.include?(type)
  end

  ##
  # Validates that duration is a positive integer
  #
  # @param duration_minutes [Integer] duration to validate
  # @raise [ArgumentError] if duration is negative or zero
  #
  def validate_duration!(duration_minutes)
    raise ArgumentError, "Duration must be positive, got: #{duration_minutes}" unless duration_minutes.positive?
  end
end
