# Total distance of the walk in feet (1 mile)
total_distance = 5280

# Calculate total time span
total_time_span = timeline["end_year"] - timeline["start_year"]

# Calculate distances and percentages for each event
for event in timeline["events"]:
    time_position = event["year"] - timeline["start_year"]
    proportional_position = time_position / total_time_span
    event_distance = proportional_position * total_distance
    event["distance_feet"] = event_distance
    event["percentage_time"] = proportional_position * 100
    event["percentage_distance"] = (event_distance / total_distance) * 100

# Ensure the final event has exactly 100% for time and distance
if timeline["events"]:
    last_event = timeline["events"][-1]
    last_event["distance_feet"] = total_distance
    last_event["percentage_time"] = 100.0
    last_event["percentage_distance"] = 100.0

# Display the results
print(f"{'Event':<35} {'Year':<10} {'Distance (feet)':<20} {'% of Total Time':<20} {'% of Total Distance':<20} {'Description'}")
print("="*140)
for event in timeline["events"]:
    print(f"{event['name']:<35} {event['year']:<10} {event['distance_feet']:<20.2f} {event['percentage_time']:<20.2f} {event['percentage_distance']:<20.2f} {event['description']}")
