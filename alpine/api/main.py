"""Main FastAPI application"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, Dict, Any
import logging

from alpine.config import settings

# Configure logging
logging.basicConfig(level=settings.log_level)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Alpine AI",
    description="AI Application Service",
    version="0.1.0",
    debug=settings.debug,
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Request/Response Models
class HealthResponse(BaseModel):
    """Health check response"""
    status: str
    version: str
    environment: str


class ChatRequest(BaseModel):
    """Chat request model"""
    message: str
    context: Optional[str] = None
    temperature: float = 0.7


class ChatResponse(BaseModel):
    """Chat response model"""
    response: str
    model: str
    tokens_used: Optional[int] = None


class AnalysisRequest(BaseModel):
    """Analysis request model"""
    text: str
    analysis_type: str = "sentiment"


class AnalysisResponse(BaseModel):
    """Analysis response model"""
    result: Dict[str, Any]
    analysis_type: str


# API Endpoints
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Welcome to Alpine AI",
        "version": "0.1.0",
        "docs": "/docs",
    }


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        version="0.1.0",
        environment=settings.api_env,
    )


@app.post("/api/v1/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Chat endpoint for conversational AI

    This is a simple example. In production, integrate with OpenAI, Anthropic, etc.
    """
    try:
        logger.info(f"Received chat request: {request.message[:50]}...")

        # Simple echo response for testing
        # TODO: Integrate with actual LLM API
        response_text = f"Echo: {request.message}"

        if settings.openai_api_key:
            # Placeholder for actual OpenAI integration
            response_text = "LLM integration ready (configure your API key)"

        return ChatResponse(
            response=response_text,
            model=settings.model_name,
            tokens_used=0,
        )
    except Exception as e:
        logger.error(f"Chat error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/analyze", response_model=AnalysisResponse)
async def analyze(request: AnalysisRequest):
    """
    Text analysis endpoint

    Supports various analysis types: sentiment, entities, keywords, etc.
    """
    try:
        logger.info(f"Analyzing text with type: {request.analysis_type}")

        # Simple mock analysis
        result = {
            "text_length": len(request.text),
            "word_count": len(request.text.split()),
            "status": "analyzed",
        }

        if request.analysis_type == "sentiment":
            result["sentiment"] = "positive"
            result["confidence"] = 0.85

        return AnalysisResponse(
            result=result,
            analysis_type=request.analysis_type,
        )
    except Exception as e:
        logger.error(f"Analysis error: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/models")
async def list_models():
    """List available AI models"""
    return {
        "models": [
            {
                "name": "gpt-4",
                "provider": "openai",
                "status": "available" if settings.openai_api_key else "not_configured",
            },
            {
                "name": "gpt-3.5-turbo",
                "provider": "openai",
                "status": "available" if settings.openai_api_key else "not_configured",
            },
        ]
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "alpine.api.main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.debug,
    )
