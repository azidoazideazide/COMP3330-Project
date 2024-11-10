# Dummy API to simulate API fetching

## Installation
1 ensure you have python3
2 get virtual environment
```
cd dummy_backend; python -m venv env
```
3 open a new command line tab, enter virtual environment
```
source env/bin/activate
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

### Not Yet Made
- `localhost:8000/grid` for grid view


## API docs and specification
check `localhost:8000/docs`