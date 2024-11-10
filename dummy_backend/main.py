from fastapi import FastAPI, HTTPException
from uuid import UUID
from typing import List
from pydantic import BaseModel
from datetime import datetime

# Define the Event model
class Event(BaseModel):
    eventId: UUID
    eventName: str
    organizerName: str
    venue: str
    description: str
    startDateTime: datetime
    tagName: str
    registerLink: str

# Create the FastAPI app
app = FastAPI()

# Dummy event data
events_data = [
    {
        "eventId": "b71e3f5c-2ed8-4e8c-bb0b-d2ee8f3a5584",
        "eventName": "Tech Talk 2024",
        "organizerName": "University Tech Society",
        "venue": "Auditorium A",
        "description": "A talk on the latest trends in tech and innovation.",
        "startDateTime": "2024-11-15T10:00:00",
        "tagName": "Technology",
        "registerLink": "https://www.google.com/search?q=techtalk2024"
    },
    {
        "eventId": "9a2a4d41-1d4b-4c3b-bf8b-2a6f7a4e753b",
        "eventName": "Art Exhibition",
        "organizerName": "Fine Arts Club",
        "venue": "Art Gallery",
        "description": "An exhibition showcasing student artwork.",
        "startDateTime": "2024-11-18T14:30:00",
        "tagName": "Arts",
        "registerLink": "https://www.google.com/search?q=artexhibition"
    },
    {
        "eventId": "c8b0e5f4-2b5f-4f8b-bc29-df0f1b5c5b56",
        "eventName": "Startup Pitch Night",
        "organizerName": "Entrepreneurship Cell",
        "venue": "Main Auditorium",
        "description": "Students pitch their startup ideas to a panel of investors.",
        "startDateTime": "2024-11-20T17:00:00",
        "tagName": "Business",
        "registerLink": "https://www.google.com/search?q=pitchnight"
    },
    {
        "eventId": "7aa7e6a2-2f3d-4bdd-af8b-2e2b7c4b4221",
        "eventName": "Music Jam",
        "organizerName": "Music Club",
        "venue": "Outdoor Amphitheater",
        "description": "A live music jam session with performances by students.",
        "startDateTime": "2024-11-22T18:00:00",
        "tagName": "Music",
        "registerLink": "https://www.google.com/search?q=musicjam"
    },
    {
        "eventId": "dc5e7eec-1c3b-4a9b-ab7d-5f71c6a5f4a6",
        "eventName": "Coding Hackathon",
        "organizerName": "Computer Science Society",
        "venue": "Room 301, CS Building",
        "description": "24-hour coding competition where teams solve real-world problems.",
        "startDateTime": "2024-11-25T09:00:00",
        "tagName": "Hackathon",
        "registerLink": "https://www.google.com/search?q=hackathon"
    },
    {
        "eventId": "e45c6a3d-8d3c-4a9d-9b7f-2c7f4e5a9b5e",
        "eventName": "Debate Championship",
        "organizerName": "Debating Society",
        "venue": "Room 204, Humanities Block",
        "description": "Inter-college debate competition on current affairs.",
        "startDateTime": "2024-11-28T13:00:00",
        "tagName": "Debate",
        "registerLink": "https://www.google.com/search?q=debatechampionship"
    },
    {
        "eventId": "a2eb5f6b-9b3d-4f8f-b7e1-d2ec6f7b7f6c",
        "eventName": "AI Workshop",
        "organizerName": "AI Research Group",
        "venue": "Room 101, Engineering Block",
        "description": "Workshop on AI and machine learning techniques.",
        "startDateTime": "2024-12-01T10:00:00",
        "tagName": "Artificial Intelligence",
        "registerLink": "https://www.google.com/search?q=aiworkshop"
    },
    {
        "eventId": "b4f7a2d0-1c7b-4e8b-bf2b-6e7b4f3a2a6b",
        "eventName": "Sports Meet",
        "organizerName": "Sports Committee",
        "venue": "University Stadium",
        "description": "Annual sports meet with events including track and field.",
        "startDateTime": "2024-12-05T08:00:00",
        "tagName": "Sports",
        "registerLink": "https://www.google.com/search?q=sportsmeet"
    },
    {
        "eventId": "2f6c5e7b-1d8b-4b8b-8b3b-1e6f3a7a3b5a",
        "eventName": "Photography Contest",
        "organizerName": "Photography Club",
        "venue": "Room 201, Arts Block",
        "description": "Photography competition with themes like nature and architecture.",
        "startDateTime": "2024-12-10T11:00:00",
        "tagName": "Photography",
        "registerLink": "https://www.google.com/search?q=photocontest"
    },
    {
        "eventId": "b7b4c5e6-2e8b-4f3b-9b5b-8e7f3c4d7e6a",
        "eventName": "Robotics Showcase",
        "organizerName": "Robotics Club",
        "venue": "Room 102, Engineering Block",
        "description": "Showcase of student-built robots and autonomous systems.",
        "startDateTime": "2024-12-12T14:00:00",
        "tagName": "Robotics",
        "registerLink": "https://www.google.com/search?q=roboticsshowcase"
    }
]

# FastAPI endpoint to get all events
@app.get("/events", response_model=List[Event])
async def get_events():
    """
    Fetch all events.
    
    Returns a list of all available events with their details.
    """
    return events_data

# New endpoint to get a single event by eventId
@app.get("/event/{eventId}", response_model=Event)
async def get_event(eventId: UUID):
    """
    Get event by eventId.
    
    Fetches the details of a specific event using its UUID. 
    Raises a 404 error if the event is not found.
    """
    # Iterate through the events to find a matching eventId
    for event in events_data:
        if event["eventId"] == str(eventId):
            return event  # Pydantic will validate and serialize the response

    # If not found, raise a 404 error
    raise HTTPException(status_code=404, detail="Event not found")