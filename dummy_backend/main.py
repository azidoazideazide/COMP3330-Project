from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
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


# Define the CoverPhoto model
class CoverPhoto(BaseModel):
    eventId: UUID
    coverPhotoLink: str


# Create the FastAPI app
app = FastAPI()

# Configure CORS
origins = [
    "http://localhost",  # Adjust as needed
    "http://localhost:8000",  # Adjust as needed
    # Add other origins if necessary
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins; for production, specify allowed origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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
        "registerLink": "https://www.google.com/search?q=techtalk2024",
    },
    {
        "eventId": "9a2a4d41-1d4b-4c3b-bf8b-2a6f7a4e753b",
        "eventName": "Art Exhibition",
        "organizerName": "Fine Arts Club",
        "venue": "Art Gallery",
        "description": "An exhibition showcasing student artwork.",
        "startDateTime": "2024-11-18T14:30:00",
        "tagName": "Arts",
        "registerLink": "https://www.google.com/search?q=artexhibition",
    },
    {
        "eventId": "c8b0e5f4-2b5f-4f8b-bc29-df0f1b5c5b56",
        "eventName": "Startup Pitch Night",
        "organizerName": "Entrepreneurship Cell",
        "venue": "Main Auditorium",
        "description": "Students pitch their startup ideas to a panel of investors.",
        "startDateTime": "2024-11-20T17:00:00",
        "tagName": "Business",
        "registerLink": "https://www.google.com/search?q=pitchnight",
    },
    {
        "eventId": "7aa7e6a2-2f3d-4bdd-af8b-2e2b7c4b4221",
        "eventName": "Music Jam",
        "organizerName": "Music Club",
        "venue": "Outdoor Amphitheater",
        "description": "A live music jam session with performances by students.",
        "startDateTime": "2024-11-22T18:00:00",
        "tagName": "Music",
        "registerLink": "https://www.google.com/search?q=musicjam",
    },
    {
        "eventId": "dc5e7eec-1c3b-4a9b-ab7d-5f71c6a5f4a6",
        "eventName": "Coding Hackathon",
        "organizerName": "Computer Science Society",
        "venue": "Room 301, CS Building",
        "description": "24-hour coding competition where teams solve real-world problems.",
        "startDateTime": "2024-11-25T09:00:00",
        "tagName": "Hackathon",
        "registerLink": "https://www.google.com/search?q=hackathon",
    },
    {
        "eventId": "e45c6a3d-8d3c-4a9d-9b7f-2c7f4e5a9b5e",
        "eventName": "Debate Championship",
        "organizerName": "Debating Society",
        "venue": "Room 204, Humanities Block",
        "description": "Inter-college debate competition on current affairs.",
        "startDateTime": "2024-11-28T13:00:00",
        "tagName": "Debate",
        "registerLink": "https://www.google.com/search?q=debatechampionship",
    },
    {
        "eventId": "a2eb5f6b-9b3d-4f8f-b7e1-d2ec6f7b7f6c",
        "eventName": "AI Workshop",
        "organizerName": "AI Research Group",
        "venue": "Room 101, Engineering Block",
        "description": "Workshop on AI and machine learning techniques.",
        "startDateTime": "2024-12-01T10:00:00",
        "tagName": "Artificial Intelligence",
        "registerLink": "https://www.google.com/search?q=aiworkshop",
    },
    {
        "eventId": "b4f7a2d0-1c7b-4e8b-bf2b-6e7b4f3a2a6b",
        "eventName": "Sports Meet",
        "organizerName": "Sports Committee",
        "venue": "University Stadium",
        "description": "Annual sports meet with events including track and field.",
        "startDateTime": "2024-12-05T08:00:00",
        "tagName": "Sports",
        "registerLink": "https://www.google.com/search?q=sportsmeet",
    },
    {
        "eventId": "2f6c5e7b-1d8b-4b8b-8b3b-1e6f3a7a3b5a",
        "eventName": "Photography Contest",
        "organizerName": "Photography Club",
        "venue": "Room 201, Arts Block",
        "description": "Photography competition with themes like nature and architecture.",
        "startDateTime": "2024-12-10T11:00:00",
        "tagName": "Photography",
        "registerLink": "https://www.google.com/search?q=photocontest",
    },
    {
        "eventId": "b7b4c5e6-2e8b-4f3b-9b5b-8e7f3c4d7e6a",
        "eventName": "Robotics Showcase",
        "organizerName": "Robotics Club",
        "venue": "Room 102, Engineering Block",
        "description": "Showcase of student-built robots and autonomous systems.",
        "startDateTime": "2024-12-12T14:00:00",
        "tagName": "Robotics",
        "registerLink": "https://www.google.com/search?q=roboticsshowcase",
    },
    {
        "eventId": "e7bf0a12-8b45-4c74-a6b3-9a3c90c3e8a9",
        "eventName": "AI Symposium 2024",
        "organizerName": "AI Research Institute",
        "venue": "Conference Hall B",
        "description": "A symposium discussing the future of artificial intelligence.",
        "startDateTime": "2024-12-05T09:30:00",
        "tagName": "Technology",
        "registerLink": "https://www.google.com/search?q=aisymposium2024",
    },
    {
        "eventId": "f4e9d6cb-3a56-4d89-bac5-b7a503f5b9e1",
        "eventName": "Fashion Show Gala",
        "organizerName": "Style Magazine",
        "venue": "Fashion Centre",
        "description": "A glamorous fashion show featuring top designers.",
        "startDateTime": "2024-12-10T19:00:00",
        "tagName": "Fashion",
        "registerLink": "https://www.google.com/search?q=fashionshowgala",
    },
    {
        "eventId": "a2c7e3f1-9a23-4b68-8c49-6d8a1b0c5e2d",
        "eventName": "Medical Tech Conference",
        "organizerName": "Healthcare Innovations Forum",
        "venue": "Medical Center Hall",
        "description": "Explore the latest advancements in medical technology.",
        "startDateTime": "2024-12-15T11:00:00",
        "tagName": "Healthcare",
        "registerLink": "https://www.google.com/search?q=medtechconference",
    },
    {
        "eventId": "b5d1f8a3-2d34-4e89-bac2-8c9e0f7a6d3b",
        "eventName": "Film Screening Series",
        "organizerName": "Cinema Enthusiasts Club",
        "venue": "Film Studio",
        "description": "Enjoy a series of classic and contemporary film screenings.",
        "startDateTime": "2024-12-20T18:30:00",
        "tagName": "Entertainment",
        "registerLink": "https://www.google.com/search?q=filmscreeningseries",
    },
    {
        "eventId": "c8b5a3d7-1b69-4f82-9a4d-3b6c2e7a1f9d",
        "eventName": "Sustainable Living Workshop",
        "organizerName": "Green Earth Society",
        "venue": "Eco Center",
        "description": "Learn about eco-friendly practices for sustainable living.",
        "startDateTime": "2024-12-25T13:00:00",
        "tagName": "Environment",
        "registerLink": "https://www.google.com/search?q=sustainablelivingworkshop",
    },
    {
        "eventId": "d8a3b6c7-2f58-4b19-8c3a-5b9f1a3e6d7c",
        "eventName": "Culinary Masterclass",
        "organizerName": "Gourmet Chefs Association",
        "venue": "Culinary Institute",
        "description": "Hands-on cooking lessons from renowned chefs.",
        "startDateTime": "2025-01-02T15:00:00",
        "tagName": "Food & Beverage",
        "registerLink": "https://www.google.com/search?q=culinarymasterclass",
    },
    {
        "eventId": "f7a2b1d9-4c59-4e89-ba2d-3f5a6b9c1d3e",
        "eventName": "Music Festival 2025",
        "organizerName": "Sound Waves Productions",
        "venue": "Outdoor Stadium",
        "description": "A weekend of live performances by top artists.",
        "startDateTime": "2025-01-10T16:00:00",
        "tagName": "Music",
        "registerLink": "https://www.google.com/search?q=musicfestival2025",
    },
    {
        "eventId": "e4b3a1f5-2c89-4f19-8b2d-4c5a1d9b3f6a",
        "eventName": "Robotics Expo",
        "organizerName": "Tech Innovations Hub",
        "venue": "Robotics Center",
        "description": "Showcase of cutting-edge robotics technology and innovations.",
        "startDateTime": "2025-01-15T10:30:00",
        "tagName": "Technology",
        "registerLink": "https://www.google.com/search?q=roboticsexpo",
    },
    {
        "eventId": "b1c9d2e8-7a35-4d98-b6a2-5f3b6a9d1c8b",
        "eventName": "Literary Symposium",
        "organizerName": "Writers Guild",
        "venue": "Library Auditorium",
        "description": "Discussions on literature, writing, and storytelling.",
        "startDateTime": "2025-01-20T14:00:00",
        "tagName": "Literature",
        "registerLink": "https://www.google.com/search?q=literarysymposium",
    },
    {
        "eventId": "f3e2b5c4-1a39-4c89-b2a5-7d9f1c3b5a2e",
        "eventName": "Virtual Reality Showcase",
        "organizerName": "VR Tech Labs",
        "venue": "Virtual Reality Center",
        "description": "Experience the latest in virtual reality technology.",
        "startDateTime": "2025-01-25T11:30:00",
        "tagName": "Technology",
        "registerLink": "https://www.google.com/search?q=vrshowcase",
    },
    {
        "eventId": "a5b3c9d1-e7f2-4a89-8c3b-1d9e6a5b3c9d",
        "eventName": "Art Exhibition",
        "organizerName": "Creative Arts Society",
        "venue": "Art Gallery",
        "description": "A showcase of contemporary art pieces.",
        "startDateTime": "2025-02-05T10:00:00",
        "tagName": "Art",
        "registerLink": "https://www.google.com/search?q=artexhibition",
    },
    {
        "eventId": "c4b9a1d5-3e7f-4b89-9c2a-5d1e3c7b9a1d",
        "eventName": "Tech Startup Summit",
        "organizerName": "Startup Hub",
        "venue": "Innovation Center",
        "description": "Bringing together tech entrepreneurs and investors.",
        "startDateTime": "2025-02-10T09:30:00",
        "tagName": "Technology",
        "registerLink": "https://www.google.com/search?q=startupsummit",
    },
    {
        "eventId": "e1d9c5b3-a7f2-4d89-9c1b-3e7f5a1d9c5b",
        "eventName": "Dance Workshop",
        "organizerName": "Dance Academy",
        "venue": "Community Center",
        "description": "Learn various dance styles from professional instructors.",
        "startDateTime": "2025-02-15T14:00:00",
        "tagName": "Performing Arts",
        "registerLink": "https://www.google.com/search?q=danceworkshop",
    },
    {
        "eventId": "b2c7a1d9-f5e3-4c89-1b2d-5a9c3b7a1d9f",
        "eventName": "Science Fair",
        "organizerName": "STEM Education Foundation",
        "venue": "Science Museum",
        "description": "Exhibits and activities showcasing scientific discoveries.",
        "startDateTime": "2025-02-20T10:00:00",
        "tagName": "Science",
        "registerLink": "https://www.google.com/search?q=sciencefair",
    },
    {
        "eventId": "d1e9b5c3-a7f2-4e89-2d1b-5c3a9f1b5d3a",
        "eventName": "Yoga Retreat",
        "organizerName": "Mindfulness Wellness Center",
        "venue": "Retreat Resort",
        "description": "A rejuvenating yoga retreat in a serene environment.",
        "startDateTime": "2025-02-25T08:00:00",
        "tagName": "Wellness",
        "registerLink": "https://www.google.com/search?q=yogaretreat",
    },
    {
        "eventId": "f2e7a1b9-d5c3-4f89-1a2d-9c5b3a7f2d5c",
        "eventName": "Photography Masterclass",
        "organizerName": "Photography Society",
        "venue": "Art Studio",
        "description": "Professional photography tips and techniques.",
        "startDateTime": "2025-03-02T11:00:00",
        "tagName": "Photography",
        "registerLink": "https://www.google.com/search?q=photographymasterclass",
    },
    {
        "eventId": "b3c9d5a1-7e2f-4b89-2d1c-5a9f3e7b1d5a",
        "eventName": "Charity Gala",
        "organizerName": "Humanitarian Foundation",
        "venue": "Grand Ballroom",
        "description": "An elegant event to raise funds for charitable causes.",
        "startDateTime": "2025-03-07T18:30:00",
        "tagName": "Charity",
        "registerLink": "https://www.google.com/search?q=charitygala",
    },
    {
        "eventId": "e5d3c9b1-2f7a-4a89-1d5c-3b9a7f2d5c3b",
        "eventName": "Fitness Expo",
        "organizerName": "Health & Fitness Expo",
        "venue": "Fitness Convention Center",
        "description": "Showcasing the latest in fitness trends and products.",
        "startDateTime": "2025-03-12T10:00:00",
        "tagName": "Fitness",
        "registerLink": "https://www.google.com/search?q=fitnessexpo",
    },
    {
        "eventId": "a1b5c3d9-f2e7-4b89-1d5c-3a9f1b5c3d9f",
        "eventName": "Gaming Tournament",
        "organizerName": "Esports League",
        "venue": "Gaming Arena",
        "description": "Compete in exciting video game tournaments.",
        "startDateTime": "2025-03-17T12:00:00",
        "tagName": "Gaming",
        "registerLink": "https://www.google.com/search?q=gamingtournament",
    },
    {
        "eventId": "d9e7b1c5-3f2a-4b89-1d5c-3b7a9f2c5d3b",
        "eventName": "Fashion Design Workshop",
        "organizerName": "Fashion Design Institute",
        "venue": "Design Studio",
        "description": "Learn fashion design techniques from industry experts.",
        "startDateTime": "2025-03-22T14:30:00",
        "tagName": "Fashion",
        "registerLink": "https://www.google.com/search?q=fashiondesignworkshop",
    },
]

# Dummy cover photos data
cover_photos_data = [
    {
        "eventId": "b71e3f5c-2ed8-4e8c-bb0b-d2ee8f3a5584",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Tech+Talk+2024",
    },
    {
        "eventId": "9a2a4d41-1d4b-4c3b-bf8b-2a6f7a4e753b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Art+Exhibition",
    },
    {
        "eventId": "c8b0e5f4-2b5f-4f8b-bc29-df0f1b5c5b56",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Startup+Pitch+Night",
    },
    {
        "eventId": "7aa7e6a2-2f3d-4bdd-af8b-2e2b7c4b4221",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Music+Jam",
    },
    {
        "eventId": "dc5e7eec-1c3b-4a9b-ab7d-5f71c6a5f4a6",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Coding+Hackathon",
    },
    {
        "eventId": "e45c6a3d-8d3c-4a9d-9b7f-2c7f4e5a9b5e",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Debate+Championship",
    },
    {
        "eventId": "a2eb5f6b-9b3d-4f8f-b7e1-d2ec6f7b7f6c",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=AI+Workshop",
    },
    {
        "eventId": "b4f7a2d0-1c7b-4e8b-bf2b-6e7b4f3a2a6b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Sports+Meet",
    },
    {
        "eventId": "2f6c5e7b-1d8b-4b8b-8b3b-1e6f3a7a3b5a",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Photography+Contest",
    },
    {
        "eventId": "b7b4c5e6-2e8b-4f3b-9b5b-8e7f3c4d7e6a",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Robotics+Showcase",
    },
    {
        "eventId": "e7bf0a12-8b45-4c74-a6b3-9a3c90c3e8a9",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=AI+Symposium+2024",
    },
    {
        "eventId": "f4e9d6cb-3a56-4d89-bac5-b7a503f5b9e1",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Fashion+Show+Gala",
    },
    {
        "eventId": "a2c7e3f1-9a23-4b68-8c49-6d8a1b0c5e2d",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Medical+Tech+Conference",
    },
    {
        "eventId": "b5d1f8a3-2d34-4e89-bac2-8c9e0f7a6d3b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Film+Screening+Series",
    },
    {
        "eventId": "c8b5a3d7-1b69-4f82-9a4d-3b6c2e7a1f9d",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Sustainable+Living+Workshop",
    },
    {
        "eventId": "d8a3b6c7-2f58-4b19-8c3a-5b9f1a3e6d7c",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Culinary+Masterclass",
    },
    {
        "eventId": "f7a2b1d9-4c59-4e89-ba2d-3f5a6b9c1d3e",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Music+Festival+2025",
    },
    {
        "eventId": "e4b3a1f5-2c89-4f19-8b2d-4c5a1d9b3f6a",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Robotics+Expo",
    },
    {
        "eventId": "b1c9d2e8-7a35-4d98-b6a2-5f3b6a9d1c8b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Literary+Symposium",
    },
    {
        "eventId": "f3e2b5c4-1a39-4c89-b2a5-7d9f1c3b5a2e",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=VR+Showcase",
    },
    {
        "eventId": "a5b3c9d1-e7f2-4a89-8c3b-1d9e6a5b3c9d",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Art+Exhibition",
    },
    {
        "eventId": "c4b9a1d5-3e7f-4b89-9c2a-5d1e3c7b9a1d",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Tech+Startup+Summit",
    },
    {
        "eventId": "e1d9c5b3-a7f2-4d89-9c1b-3e7f5a1d9c5b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Dance+Workshop",
    },
    {
        "eventId": "b2c7a1d9-f5e3-4c89-1b2d-5a9c3b7a1d9f",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Science+Fair",
    },
    {
        "eventId": "d1e9b5c3-a7f2-4e89-2d1b-5c3a9f1b5d3a",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Yoga+Retreat",
    },
    {
        "eventId": "f2e7a1b9-d5c3-4f89-1a2d-9c5b3a7f2d5c",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Photography+Masterclass",
    },
    {
        "eventId": "b3c9d5a1-7e2f-4b89-2d1c-5a9f3e7b1d5a",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Charity+Gala",
    },
    {
        "eventId": "e5d3c9b1-2f7a-4a89-1d5c-3b9a7f2d5c3b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Fitness+Expo",
    },
    {
        "eventId": "a1b5c3d9-f2e7-4b89-1d5c-3a9f1b5c3d9f",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Gaming+Tournament",
    },
    {
        "eventId": "d9e7b1c5-3f2a-4b89-1d5c-3b7a9f2c5d3b",
        "coverPhotoLink": "https://dummyimage.com/400x400/000/fff&text=Fashion+Design+Workshop",
    },
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


# FastAPI endpoint to get all cover photos
@app.get("/coverPhotos/", response_model=List[CoverPhoto])
async def get_cover_photos():
    """
    Get a list of eventId-coverPhotoLink pair
    """
    return cover_photos_data
