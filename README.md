# 🎉 EventHub – Frontend (Flutter)

EventHub is a modern web application designed to **explore, create, and manage events** with role-based access.  
This repository contains the **frontend** of the EventHub system, developed using **Flutter Web**.

---

## 🚀 Features

### 🌐 Public Users
- Explore published events
- View event details
- Responsive and user-friendly UI

### 👤 Registered Users
- Secure login & registration with form validation
- User dashboard panel
- Create and publish own events
- Update and delete own events
- JWT-based authentication handling

### 🛠️ Admin Users
- Admin dashboard
- Manage all users in the system
- View, update, and delete all events
- Full system control with role-based access

---

## 🧰 Tech Stack

| Technology | Description |
|---------|-------------|
| **Flutter** | Frontend framework |
| **Dart** | Programming language |
| **Flutter Web** | Web deployment |
| **REST API** | Backend communication |
| **JWT Authentication** | Secure user authentication |
| **Material UI** | Clean and modern UI design |

---

## 🔐 Authentication & Security

- Uses **JWT (JSON Web Token)** for authentication
- Tokens are securely stored and attached to API requests
- Role-based UI rendering (**Admin / User**)
- Session handling with protected routes

---

## 📦 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── services/
│   └── utils/
│
├── models/
│   ├── user_model.dart
│   └── event_model.dart
│
├── screens/
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   │
│   ├── admin/
│   │   └── admin_dashboard.dart
│   │
│   ├── user/
│   │   └── user_dashboard.dart
│   │
│   └── public/
│       └── event_list.dart
│
├── widgets/
│   ├── custom_button.dart
│   └── form_fields.dart
│
└── main.dart
