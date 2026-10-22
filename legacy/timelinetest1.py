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

# Total distance of the walk in feet (1 mile)
total_distance = 5280

# Calculate total time span
total_time_span = timeline["end_year"] - timeline["start_year"]

# Calculate distances for each event
for event in timeline["events"]:
    time_position = event["year"] - timeline["start_year"]
    proportional_position = time_position / total_time_span
    event_distance = proportional_position * total_distance
    event["distance_feet"] = event_distance

# Display the results
import ace_tools as tools
import pandas as pd

df = pd.DataFrame(timeline["events"])
tools.display_dataframe_to_user("Mayan Timeline Distances", df)
