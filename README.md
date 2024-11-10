# COMP3330-Project: HKU EventEase

## Overview
**HKU EventEase** is a mobile application designed to simplify this process by offering a centralized platform for discovering, browsing and filtering upcoming activities in real-time.

## Installation

### Flutter App Installation
1. clone this repo
2. install flutter SDK by the following guide
   - [Windows](https://docs.flutter.dev/get-started/install/windows/mobile)
   - [Mac](https://docs.flutter.dev/get-started/install/macos/mobile-android)
   - [Linux](https://docs.flutter.dev/get-started/install/linux/android) 
3. install the flutter dependencies `flutter pub get`
4. Start a new Android Device (API Level 35) which should have done in the flutter SDK install guide
5. run the app by `flutter run` or click in the android studio

### Dummy Python API Installation
1 ensure you have python
2 get virtual environment
```
python3 -m venv env
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

## Coding Standards

Follow the [Flutter Style Guide](https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md)

### Code Style Guidelines
- **Indentation**: use 2 spaces
- **Line Length** : Aim a maximum line length of 80-120 characters
- **Naming Conventions**:
	- `lowerCamelCase` for variables and function names
	- `UpperCamelCase` for class names
	- `snake_case` for file names

## Contributing
1. Create a branch for a new feature: `git checkout -b feature/your-feature-name`
2. Commit your changes with meaningful message  
    - Follow the [Git Commit Message Convention](https://www.conventionalcommits.org/en/v1.0.0/)
	- One-line: `git commit -m "<type>[optional scope]: <description>"`
    - Detailed: `git commit`
    - ```git
        <type>[optional scope]: <description>
    
        [optional body]
    
        [optional footer(s)]    
        ```
3. Push to the repo: `git push origin feature/your-feature-name`
4. Do not push UNTESTED CODE to the main branch
