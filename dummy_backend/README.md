# Dummy API to simulate API fetching

## Installation
1 ensure you have python3
2 get virtual environment
```
cd dummy_backend; python -m venv env
```
3 open a new command line tab, enter virtual environment
```
For windows users
PowerShell as Administrator
Enter command: Set-ExecutionPolicy RemoteSigned
Then run .\env\Scripts\Activate

For MAC users
source env/bin/activate
```
4 install dependencies for FastAPI 
```
pip install -r requirements.txt
```
5 run the api
```
uvicorn your_app:app --host 0.0.0.0 --port 8000
//please use 0.0.0.0 as host, as emulator phone cannot access localhost
```

## Possible API link
<ipv4> is your ipv4
Obtain by enter command ipconfig in PowerShell

usually be `<ipv4>:8000`
- `<ipv4>:8000/event/{eventId}` for detail view
- `<ipv4>:8000/events` for list view
- `<ipv4>:8000/coverPhotos` for grid view


## API docs and specification
check `<ipv4>:8000/docs`