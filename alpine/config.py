"""Application configuration"""
from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    """Application settings"""

    # API Configuration
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_env: str = "development"

    # AI Model Configuration
    openai_api_key: str = ""
    model_name: str = "gpt-4"

    # Application Settings
    log_level: str = "INFO"
    debug: bool = True

    # Vector Database
    chroma_persist_directory: str = "./data/chroma"

    # CORS Settings
    allowed_origins: List[str] = [
        "http://localhost:3000",
        "http://localhost:8000",
    ]

    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
