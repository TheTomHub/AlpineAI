# 🚀 Quick Start - Test Alpine AI in 3 Minutes!

For your M2 MacBook - the fastest way to test today.

## Method 1: Simple Setup (Recommended for M2 Mac)

Open Terminal and run these commands:

```bash
# Navigate to project
cd AlpineAI

# Run setup
bash scripts/setup.sh

# Activate environment
source venv/bin/activate

# Start the server
python -m uvicorn alpine.api.main:app --reload
```

**That's it!** Now open your browser:
- 📖 **Interactive API Docs**: http://localhost:8000/docs
- ✅ **Health Check**: http://localhost:8000/health
- 🏠 **Home**: http://localhost:8000

## Method 2: Docker (Easiest, No Setup)

If you have Docker Desktop installed:

```bash
cd AlpineAI
docker-compose up
```

Same URLs as above!

## Test the API

### In Browser:
Go to http://localhost:8000/docs and try the endpoints interactively!

### In Terminal:
Open a new terminal window:

```bash
# Test chat
curl -X POST "http://localhost:8000/api/v1/chat" \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello Alpine!"}'

# Test analysis
curl -X POST "http://localhost:8000/api/v1/analyze" \
  -H "Content-Type: application/json" \
  -d '{"text": "This is awesome!", "analysis_type": "sentiment"}'
```

## What You Get

- ✅ FastAPI server running on port 8000
- ✅ Interactive API documentation
- ✅ Health check endpoint
- ✅ Chat endpoint (ready for LLM integration)
- ✅ Text analysis endpoint
- ✅ Auto-reload on code changes

## Next Steps

1. **Add your OpenAI API key** (optional):
   ```bash
   # Edit .env file
   nano .env
   # Add: OPENAI_API_KEY=sk-...
   ```

2. **Customize the endpoints** in `alpine/api/main.py`

3. **Add your AI models** in `alpine/models/`

## Troubleshooting

**Port 8000 already in use?**
```bash
lsof -ti:8000 | xargs kill -9
```

**Need help?**
Read the full README.md for detailed instructions!

---

**You're ready to build!** 🎉
