# frozen_string_literal: true

##
# Event Router (Subject/Observable)
#
# Responsibility: Maintain a collection of handlers and notify them of events
# SOLID Principle: Single Responsibility - event dispatch only
#                  Open/Closed - new handlers can be added without router modification
#                  Liskov Substitution - all handlers are interchangeable
#                  Dependency Inversion - depends on EventHandler abstraction
#
# This class implements the Observer pattern. It maintains a registry of handlers
# and dispatches events to all of them. Critically, it has ZERO knowledge of
# concrete handler types - it only references the EventHandler abstraction.
# This ensures true decoupling and allows new handlers to be added without
# modifying this class.
#
class EventRouter
  ##
  # Initialize the router with an empty handler collection
  #
  def initialize
    @handlers = []
  end

  ##
  # Register a handler to receive events
  #
  # @param handler [EventHandler] The handler to register
  # @raise [ArgumentError] if handler doesn't respond to handle method
  #
  def register(handler)
    raise ArgumentError, "Handler must respond to handle(event)" unless handler.respond_to?(:handle)

    @handlers << handler
  end

  ##
  # Unregister a handler from receiving events
  #
  # @param handler [EventHandler] The handler to remove
  #
  def unregister(handler)
    @handlers.delete(handler)
  end

  ##
  # Dispatch an event to all registered handlers
  #
  # Each handler is called with the same event object. If a handler raises
  # an exception, it is caught and logged, but other handlers still receive
  # the event (fail-safe behavior).
  #
  # @param event [Event] The event to dispatch
  #
  def dispatch(event)
    @handlers.each do |handler|
      handler.handle(event)
    rescue StandardError => e
      warn "Error in #{handler.class}: #{e.message}"
    end
  end

  ##
  # Returns the number of registered handlers
  #
  # @return [Integer] number of handlers
  #
  def handler_count
    @handlers.size
  end

  ##
  # Returns all registered handlers (for testing purposes)
  #
  # @return [Array<EventHandler>] copy of handlers array
  #
  def handlers
    @handlers.dup
  end
end
