# 🎉 EventHub – Frontend (Flutter)

EventHub is a modern web application designed to **explore, create, and manage events** with role-based access control.  
This repository contains the **frontend** of the EventHub system, developed using **Flutter Web**.

---

## 🚀 Features

### 🌐 Public Users
- Explore published events
- View event details
- Responsive and user-friendly UI

### 👤 Registered Users
- Secure login and registration with form validation
- User dashboard panel
- Create and publish own events
- Update and delete own events
- JWT-based authentication handling

### 🛠️ Admin Users
- Admin dashboard
- Manage all system users
- View, update, and delete all events
- Full system control with role-based access

---

## 🧰 Tech Stack

| Technology | Description |
|----------|-------------|
| **Flutter** | Frontend framework |
| **Dart** | Programming language |
| **Flutter Web** | Web application deployment |
| **REST API** | Backend communication |
| **JWT Authentication** | Secure user authentication |
| **Material UI** | Clean and modern UI design |

---

## 🔐 Authentication & Security

- Uses **JWT (JSON Web Token)** for authentication
- Tokens are securely stored and attached to API requests
- Role-based UI rendering (**Admin / User**)
- Protected routes for secure navigation

---

## ⚙️ Build and Run the Flutter Web Application

This project is built using **Flutter Web** and communicates with a **Spring Boot backend** through REST APIs.

---

## ✅ Prerequisites

- **Flutter SDK** (latest stable version)
- **Dart SDK** (included with Flutter)
- **Google Chrome** (recommended browser)
- A running **Spring Boot backend API**

---

## ▶️Build for Production (Flutter Web)

```bash
flutter build web

After a successful build, the output will be located in:

build/web/
(This folder can be deployed to any static web hosting service.)


