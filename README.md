# GITLs (Garbage Identifier Timor Leste)

GITLs is an AI-powered web application built with Elixir and Phoenix Framework that identify and properly dispose of waste materials. Using machine learning through the Together AI API, it provides instant identification and disposal recommendations for various types of garbage.

## Demo Video

[Watch Demo](your_demo_video_link)

## Why GITLs?

Waste management is a significant challenge in Timor-Leste. GITLs aims to address this by providing an accessible, easy-to-use tool that:

- Instantly identifies different types of waste materials
- Provides specific disposal recommendations

## Technologies Used

### Backend

- **Elixir**: A functional programming language designed for building scalable and maintainable applications
- **Phoenix Framework**: A powerful web framework built on Elixir
- **Together AI API**: For image recognition and analysis

### Frontend

- **Phoenix LiveView**: For real-time UI updates without JavaScript
- **TailwindCSS**: For responsive and modern styling
- **Alpine.js**: For lightweight JavaScript interactions

### Features

- Real-time image recognition
- Instant waste classification
- Disposal recommendations

## Installation and Setup

### Prerequisites

- Elixir 1.14 or later
- Erlang/OTP 24 or later
- Git

### Clone and Installation

1. Clone the repository:

```bash
git clone https://github.com/ajitonelsonn/garbageidentify.git
cd garbageidentify
```

2. Install Elixir dependencies:

```bash
mix deps.get
mix compile
```

3. Set up environment variables:
   Create a `config/dev.secret.exs` file with:

```elixir
import Config

config :garbageidentify, :together_api,
  api_key: "your_together_api_key"
```

4. Install and set up the frontend:

```bash
cd assets
npm install
cd ..
```

5. Setup the database:

```bash
mix ecto.setup
```

6. Start the Phoenix server:

```bash
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) to see the application.

### Troubleshooting

- If you get any compilation errors, try:
  ```bash
  mix deps.clean --all
  mix deps.get
  mix compile
  ```

## Social Media

- Discord: ajitonelson\_
- X: [@ajitonelson](https://x.com/ajitonelson)
- LinkedIn: [@ajitonelson](https://www.linkedin.com/in/ajitonelson/)
