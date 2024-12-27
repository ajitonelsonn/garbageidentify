# GITL

GITLs is an AI-powered web application built with Elixir and Phoenix Framework that identify and properly dispose of waste materials. Using machine learning through the Together AI API, it provides instant identification and disposal recommendations for various types of garbage.

## Demo Video

[![GITLs Demo](https://img.youtube.com/vi/6NJ1-PGFSns/0.jpg)](https://www.youtube.com/watch?v=6NJ1-PGFSns)

[Watch Full Demo on YouTube](https://www.youtube.com/watch?v=6NJ1-PGFSns)


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
- Git

### Clone and Installation

1. Clone the repository:

```bash
git clone https://github.com/ajitonelsonn/garbageidentify.git
cd garbageidentify
```

2. Set up environment variables:
   Create a `config/dev.secret.exs` file with:

```elixir
import Config

config :garbageidentify, :together_api,
  api_key: "your_together_api_key"
```

3. Install Elixir dependencies:

```bash
mix deps.get
mix compile
```

4. Start the Phoenix server:

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
