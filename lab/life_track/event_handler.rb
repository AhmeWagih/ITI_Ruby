# frozen_string_literal: true

##
# Event Handler Abstraction (Interface)
#
# Responsibility: Define the contract that all event handlers must follow
# SOLID Principle: Interface Segregation - single method interface
#                  Dependency Inversion - concrete handlers depend on this abstraction
#
# This is the abstraction that enables the Strategy pattern. All handlers must
# implement the handle(event) method. Using NotImplementedError at runtime ensures
# that subclasses cannot be instantiated without providing an implementation.
#
class EventHandler
  ##
  # Handles an event with a specific strategy
  #
  # This method MUST be implemented by all subclasses. It serves as the
  # single point of contact for the EventRouter, ensuring all handlers
  # are interchangeable and follow the same interface.
  #
  # @param event [Event] The event to handle
  # @raise [NotImplementedError] if not implemented by subclass
  #
  def handle(event)
    raise NotImplementedError, "#{self.class} must implement handle(event) method"
  end
end
