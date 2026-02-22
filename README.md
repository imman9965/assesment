this app is a production-ready Flutter quiz application built using Flutter SDK 3.29.0 that demonstrates modern mobile application development using:

Clean MVVM Architecture

Firebase Backend Integration

REST API Integration

JSON Serialization

Secure Authentication

State Management using Provider

The application fetches real-time quiz questions from the Open Trivia Database API and provides multiple authentication methods powered by Firebase.

This project was developed to showcase scalable architecture, proper state management, backend integration, and production-level app structure.

🚀 Core Features
🎯 Quiz Engine

Real-time quiz questions from OpenTDB

Multiple difficulty levels

Different quiz modes (5, 10, 20 questions)

Automatic score calculation

Result summary screen

Dynamic option rendering

Loading indicators during API calls

Error handling for API rate limits (HTTP 429)

🌍 Third-Party API Integration
🔗 Open Trivia Database API

API Endpoint:

https://opentdb.com/api.php

Example request:

https://opentdb.com/api.php?amount=10&type=multiple

Implementation includes:

RESTful API consumption

Dio HTTP client

JSON parsing using json_serializable

Model generation

Repository pattern

Proper async handling

This demonstrates production-level API integration.

🔐 Firebase Integration

The application integrates Firebase for secure authentication and backend features.

✅ Firebase Authentication Includes:
1. Email & Password Login

Secure account creation

Password validation

Persistent user sessions

2. Google Sign-In

OAuth-based login

Secure credential handling

3. Forgot Password

Email reset link

Firebase reset flow

4. Phone Number OTP Verification

SMS-based verification

Firebase phone authentication

Verification code handling

Secure account linking


this set up for ready to move on upload play store i commended some configs build.gradle because you need to run in debug mode
i already generate key-store file and create key.properties file