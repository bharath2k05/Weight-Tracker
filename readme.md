# Weight Tracker Application

Hello Visitor,

Welcome to the Weight Tracker application! This is a simple application designed to track your anthropometry details such as Weight, Age, and Height.

## Backend Setup

1. **Requirements**:
   - Python >= 3.9 should be installed on your device.
   - Navigate to the `backend` directory.

2. **Install Dependencies**:
   - Run `pip install -r requirements.txt` to install all the required packages.

3. **Database Setup**:
   - Execute the following commands to set up the database:
     ```
     python manage.py makemigrations
     python manage.py migrate
     ```

4. **Run the Server**:
   - Start the Django server by running `python manage.py runserver`.

## Frontend Setup

1. **Flutter Setup**:
   - Make sure you have Flutter SDK installed on your device and added to your PATH.
   - Install Flutter and Dart extensions in your IDE.

2. **Dependencies Installation**:
   - Navigate to the `frontend` directory and run `flutter pub get` to install all the dependencies.

3. **Run the Frontend**:
   - Start the frontend by running `flutter run`.
   - Ensure that the backend server is running to enable registration, sign-in, and access to the application.

## Author
This application is developed by Bharath Kannan.

Feel free to explore the application and provide any feedback or suggestions.

Best Regards,
Bharath Kannan
