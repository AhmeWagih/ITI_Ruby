# frozen_string_literal: true

require 'json'
require_relative 'event_handler'

##
# HTML Handler (Concrete Strategy)
#
# Responsibility: Regenerate a dashboard HTML file on every event
# SOLID Principle: Single Responsibility - HTML dashboard generation
#                  Liskov Substitution - interchangeable with other handlers
#
# This handler implements the strategy of maintaining a real-time HTML dashboard.
# On each event, it reads the current events.log, parses all events, and
# regenerates the dashboard.html file with updated statistics and event list.
#
class HTMLHandler < EventHandler
  LOG_FILE = 'events.log'
  DASHBOARD_FILE = 'dashboard.html'

  ##
  # Regenerates the HTML dashboard with all logged events
  #
  # @param event [Event] The event to handle (not directly used, only triggers regeneration)
  #
  def handle(event)
    events = read_logged_events
    html_content = generate_dashboard_html(events)
    File.write(DASHBOARD_FILE, html_content)
    puts "✓ Dashboard regenerated: #{DASHBOARD_FILE}"
  end

  private

  ##
  # Reads all events from the log file
  #
  # @return [Array<Hash>] parsed event hashes
  #
  def read_logged_events
    return [] unless File.exist?(LOG_FILE)

    File.readlines(LOG_FILE).map { |line| JSON.parse(line, symbolize_names: true) }
  rescue JSON::ParsingError
    []
  end

  ##
  # Generates HTML dashboard content with event statistics
  #
  # @param events [Array<Hash>] list of events
  # @return [String] complete HTML document
  #
  def generate_dashboard_html(events)
    stats = calculate_stats(events)

    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>LifeTrack Dashboard</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); margin: 0; padding: 20px; }
          .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
          h1 { color: #333; border-bottom: 3px solid #667eea; padding-bottom: 10px; }
          .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }
          .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
          .stat-value { font-size: 32px; font-weight: bold; }
          .stat-label { font-size: 14px; opacity: 0.9; }
          .events-list { margin-top: 30px; }
          .event-item { background: #f5f5f5; padding: 15px; margin: 10px 0; border-left: 4px solid #667eea; border-radius: 4px; }
          .event-type { font-weight: bold; color: #667eea; text-transform: uppercase; font-size: 12px; }
          .event-desc { margin: 5px 0; }
          .event-time { font-size: 12px; color: #999; }
          .empty { text-align: center; color: #999; font-style: italic; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>📊 LifeTrack Dashboard</h1>
          <div class="stats">
            <div class="stat-card">
              <div class="stat-value">#{stats[:total_events]}</div>
              <div class="stat-label">Total Events</div>
            </div>
            <div class="stat-card">
              <div class="stat-value">#{stats[:total_minutes]}</div>
              <div class="stat-label">Total Minutes</div>
            </div>
            <div class="stat-card">
              <div class="stat-value">#{stats[:avg_duration]}</div>
              <div class="stat-label">Avg Duration (min)</div>
            </div>
          </div>
          <div class="events-list">
            <h2>📋 Recent Events</h2>
            #{events.empty? ? '<p class="empty">No events logged yet</p>' : events.map { |e| format_event_html(e) }.join}
          </div>
          <p style="text-align: center; color: #999; font-size: 12px; margin-top: 30px;">Generated at: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}</p>
        </div>
      </body>
      </html>
    HTML
  end

  ##
  # Formats a single event as HTML
  #
  # @param event [Hash] event data
  # @return [String] HTML event item
  #
  def format_event_html(event)
    timestamp = event[:timestamp].is_a?(Time) ? event[:timestamp].strftime('%Y-%m-%d %H:%M:%S') : event[:timestamp]
    <<~HTML
      <div class="event-item">
        <div class="event-type">#{event[:type]}</div>
        <div class="event-desc">#{event[:description]}</div>
        <div>Duration: #{event[:duration_minutes]} minutes</div>
        <div class="event-time">#{timestamp}</div>
      </div>
    HTML
  end

  ##
  # Calculates statistics from events
  #
  # @param events [Array<Hash>] list of events
  # @return [Hash] statistics
  #
  def calculate_stats(events)
    total_events = events.size
    total_minutes = events.sum { |e| e[:duration_minutes].to_i }
    avg_duration = total_events.zero? ? 0 : (total_minutes / total_events).round(1)

    {
      total_events: total_events,
      total_minutes: total_minutes,
      avg_duration: avg_duration
    }
  end
end
