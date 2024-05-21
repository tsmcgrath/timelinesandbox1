# Here's a flexible function to calculate event positions based on user input for total duration (in minutes) or total distance (in feet)
def calculate_event_positions(timeline, total_duration=None, total_distance=None):
    if total_duration is None and total_distance is None:
        raise ValueError("Either total_duration or total_distance must be provided.")
    
    # Calculate total time span
    total_time_span = timeline["end_year"] - timeline["start_year"]
    
    # Calculate positions for each event
    for event in timeline["events"]:
        time_position = event["year"] - timeline["start_year"]
        proportional_position = time_position / total_time_span
        
        if total_duration is not None:
            event_position = proportional_position * total_duration
            event["position"] = event_position
            event["unit"] = "minutes"
        elif total_distance is not None:
            event_position = proportional_position * total_distance
            event["position"] = event_position
            event["unit"] = "feet"
    
    return timeline

# Example data
timeline = {
    "start_year": -2000,
    "end_year": 1697,
    "events": [
        {"name": "Early Maya Settlements", "year": -2000, "description": "The earliest Maya settlements begin to form."},
        {"name": "Development of Writing System", "year": -500, "description": "The Maya develop a sophisticated writing system."},
        {"name": "Rise of El Mirador", "year": -300, "description": "El Mirador becomes a major city."},
        {"name": "Peak of Tikal", "year": 600, "description": "Tikal reaches its peak power."},
        {"name": "Construction of Temple IV", "year": 741, "description": "Tikal's Temple IV is completed."},
        {"name": "Fall of Teotihuacan", "year": 750, "description": "Teotihuacan falls, impacting Maya politics."},
        {"name": "Rise of Chichen Itza", "year": 1000, "description": "Chichen Itza becomes a major regional capital."},
        {"name": "Spanish Conquest", "year": 1697, "description": "The Spanish conquer the last independent Maya city."}
    ]
}

# Example usage
total_duration = 60  # 1 hour in minutes
calculated_timeline = calculate_event_positions(timeline, total_duration=total_duration)

# Display the results
print(f"{'Event':<30} {'Year':<10} {'Position (minutes)':<20} {'Description'}")
print("="*90)
for event in calculated_timeline["events"]:
    print(f"{event['name']:<30} {event['year']:<10} {event['position']:<20.2f} {event['description']}")

total_distance = 5280  # 1 mile in feet
calculated_timeline = calculate_event_positions(timeline, total_distance=total_distance)

# Display the results
print(f"\n{'Event':<30} {'Year':<10} {'Position (feet)':<20} {'Description'}")
print("="*90)
for event in calculated_timeline["events"]:
    print(f"{event['name']:<30} {event['year']:<10} {event['position']:<20.2f} {event['description']}")
