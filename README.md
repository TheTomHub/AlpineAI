# 🏔️ Alpine AI

A modern AI application framework built with FastAPI, optimized for Apple Silicon (M2 Mac).

## ✨ Features

- 🚀 FastAPI-based REST API
- 🤖 AI/ML integration ready (OpenAI, LangChain, etc.)
- 🐳 Docker support for easy deployment
- 🔥 Optimized for M2 Mac with ARM64 support
- 📊 Built-in API documentation (Swagger/OpenAPI)
- 🧪 Testing framework included
- 🔧 Easy configuration with environment variables

## 📋 Prerequisites (M2 Mac)

Before you begin, ensure you have the following installed:

1. **Homebrew** (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Python 3.11+**:
   ```bash
   brew install python@3.11
   ```

3. **Docker Desktop for Apple Silicon** (optional, for containerized testing):
   - Download from: https://www.docker.com/products/docker-desktop
   - Choose the **Apple Silicon** version

## 🚀 Quick Start (Fastest Way to Test Today!)

### Option 1: Using the Setup Script (Recommended)

```bash
# Clone the repository (if not already done)
cd AlpineAI

# Run the setup script
bash scripts/setup.sh

# Activate the virtual environment
source venv/bin/activate

# Start the server
python -m uvicorn alpine.api.main:app --reload
```

The API will be available at:
- **API**: http://localhost:8000
- **Interactive Docs**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc

### Option 2: Using Docker (Easiest)

```bash
# Build and run with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop when done
docker-compose down
```

### Option 3: Using Makefile

```bash
# Setup everything
make setup

# Activate venv
source venv/bin/activate

# Run the application
make run
```

## 📝 Step-by-Step Setup Instructions

### 1. Clone and Navigate
```bash
cd AlpineAI
```

### 2. Create Virtual Environment
```bash
python3.11 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Configure Environment
```bash
# Copy the example env file
cp .env.example .env

# Edit .env with your settings (optional for basic testing)
nano .env
```

### 5. Run the Application
```bash
# Development mode with auto-reload
python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0 --port 8000
```

### 6. Test the API
Open a new terminal and run:
```bash
# Make the test script executable
chmod +x scripts/test.sh

# Run tests
bash scripts/test.sh
```

Or test manually:
```bash
# Health check
curl http://localhost:8000/health

# Chat endpoint
curl -X POST http://localhost:8000/api/v1/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello Alpine!", "temperature": 0.7}'

# Analysis endpoint
curl -X POST http://localhost:8000/api/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{"text": "This is amazing!", "analysis_type": "sentiment"}'
```

## 🔌 API Endpoints

### Core Endpoints
- `GET /` - Welcome message
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation

### AI Endpoints
- `POST /api/v1/chat` - Conversational AI endpoint
- `POST /api/v1/analyze` - Text analysis endpoint
- `GET /api/v1/models` - List available models

## 📁 Project Structure

```
AlpineAI/
├── alpine/              # Main application package
│   ├── api/            # API endpoints
│   │   └── main.py     # FastAPI application
│   ├── models/         # AI models
│   ├── services/       # Business logic
│   ├── utils/          # Utilities
│   ├── tests/          # Tests
│   └── config.py       # Configuration
├── scripts/            # Utility scripts
│   ├── setup.sh       # Setup script
│   └── test.sh        # Test script
├── config/            # Configuration files
├── data/              # Data storage
├── requirements.txt   # Python dependencies
├── Dockerfile         # Docker configuration
├── docker-compose.yml # Docker Compose setup
├── Makefile          # Make commands
└── README.md         # This file
```

## 🛠️ Development

### Running Tests
```bash
# With pytest
pytest tests/ -v

# With coverage
make test
```

### Code Quality
```bash
# Format code
black alpine/

# Lint code
ruff check alpine/
```

### Docker Commands
```bash
# Build image
make docker-build

# Run container
make docker-run

# Stop container
make docker-stop

# View logs
docker-compose logs -f alpine-api
```

## ⚙️ Configuration

Edit `.env` to configure:

```env
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000
API_ENV=development

# AI Configuration
OPENAI_API_KEY=your_key_here
MODEL_NAME=gpt-4

# Logging
LOG_LEVEL=INFO
DEBUG=true
```

## 🔥 M2 Mac Optimizations

This project is optimized for Apple Silicon:

1. **ARM64 Docker Images**: Uses `linux/arm64` platform
2. **Native Python**: Runs natively on M2 without Rosetta
3. **Optimized ML Libraries**: PyTorch and TensorFlow configured for Metal acceleration
4. **Fast Build Times**: Multi-stage Docker builds

### Installing ML Frameworks (Optional)

For TensorFlow with M2 GPU acceleration:
```bash
pip install tensorflow-macos tensorflow-metal
```

For PyTorch (already in requirements.txt):
```bash
pip install torch torchvision torchaudio
```

## 🧪 Testing the API

### Using the Interactive Docs
1. Go to http://localhost:8000/docs
2. Click on any endpoint
3. Click "Try it out"
4. Fill in the parameters
5. Click "Execute"

### Using cURL
```bash
# Test chat
curl -X POST "http://localhost:8000/api/v1/chat" \
     -H "Content-Type: application/json" \
     -d '{"message": "What can you do?", "temperature": 0.7}'

# Test analysis
curl -X POST "http://localhost:8000/api/v1/analyze" \
     -H "Content-Type: application/json" \
     -d '{"text": "I love this product!", "analysis_type": "sentiment"}'
```

### Using Python
```python
import requests

# Chat request
response = requests.post(
    "http://localhost:8000/api/v1/chat",
    json={"message": "Hello!", "temperature": 0.7}
)
print(response.json())
```

## 📚 Next Steps

1. **Add Your AI Logic**: Implement your AI models in `alpine/models/`
2. **Connect to LLMs**: Add OpenAI/Anthropic API keys in `.env`
3. **Add Vector DB**: Configure ChromaDB for embeddings
4. **Custom Endpoints**: Add your endpoints in `alpine/api/`
5. **Deploy**: Use Docker for production deployment

## 🤝 Contributing

This is your project! Modify and extend as needed.

## 📄 License

Your choice!

## 🆘 Troubleshooting

### Port Already in Use
```bash
# Find process using port 8000
lsof -ti:8000 | xargs kill -9

# Or use a different port
python -m uvicorn alpine.api.main:app --reload --port 8001
```

### Virtual Environment Issues
```bash
# Remove and recreate
rm -rf venv
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Docker Issues on M2
```bash
# Ensure you're using Apple Silicon version of Docker Desktop
docker --version

# Rebuild without cache
docker-compose build --no-cache
```

---

**Ready to test?** Just run:
```bash
bash scripts/setup.sh && source venv/bin/activate && make run
```

Then visit http://localhost:8000/docs and start testing! 🚀
