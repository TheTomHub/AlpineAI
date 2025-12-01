#!/bin/bash
# Quick test script for Alpine AI

set -e

echo "🧪 Testing Alpine AI..."

# Check if server is running
if ! curl -s http://localhost:8000/health > /dev/null; then
    echo "❌ Server is not running. Start it first with:"
    echo "   python -m uvicorn alpine.api.main:app --reload"
    exit 1
fi

echo "✅ Server is running"
echo ""

# Test health endpoint
echo "📊 Testing /health endpoint..."
curl -s http://localhost:8000/health | python3 -m json.tool
echo ""

# Test chat endpoint
echo "💬 Testing /api/v1/chat endpoint..."
curl -s -X POST http://localhost:8000/api/v1/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello Alpine!", "temperature": 0.7}' | python3 -m json.tool
echo ""

# Test analyze endpoint
echo "🔍 Testing /api/v1/analyze endpoint..."
curl -s -X POST http://localhost:8000/api/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{"text": "This is a great day!", "analysis_type": "sentiment"}' | python3 -m json.tool
echo ""

# Test models endpoint
echo "🤖 Testing /api/v1/models endpoint..."
curl -s http://localhost:8000/api/v1/models | python3 -m json.tool
echo ""

echo "✅ All tests passed!"
