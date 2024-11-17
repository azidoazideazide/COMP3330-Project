# Dummy API to simulate API fetching

## Installation
1 ensure you have python3  
2 get virtual environment  
(macOS/Linux)  
```
cd dummy_backend; python -m venv env
```
(Windows)
```
cd dummy_backend; py -3 -m venv .venv
```
3 open a new command line tab, enter virtual environment  
(macOS/Linux)  
```
source env/bin/activate
```
(Windows)
```
Set-ExecutionPolicy RemoteSigned
.\env\Scripts\Activate
```
4 install dependencies for FastAPI 
```
pip install -r requirements.txt
```
5 run the api
```
uvicorn main:app --reload
```

## Possible API link
usually be `localhost:8000`
- `localhost:8000/event/{eventId}` for detail view
- `localhost:8000/events` for list view
- `localhost:8000/coverPhotos` for grid view


## API docs and specification
check `localhost:8000/docs`
