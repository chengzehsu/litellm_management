#!/usr/bin/env python3
"""
Gemini Usage Dashboard
A simple web dashboard to view Gemini model usage from Langfuse
"""

import os
from flask import Flask, render_template, jsonify
from langfuse import Langfuse
from datetime import datetime, timedelta
import json

app = Flask(__name__)

# Initialize Langfuse client
langfuse = Langfuse(
    public_key=os.getenv("LANGFUSE_PUBLIC_KEY"),
    secret_key=os.getenv("LANGFUSE_SECRET_KEY"),
    host=os.getenv("LANGFUSE_HOST", "https://cloud.langfuse.com")
)

# Gemini models to track
GEMINI_MODELS = [
    "gemini-3-pro",
    "gemini-3-flash",
    "gemini-3-deep-think",
    "gemini-2.5-pro",
    "gemini-2.5-flash",
    "gemini-2.5-flash-lite",
    "gemini-3-pro-image",
    "gemini-live-3-flash",
]


@app.route('/')
def index():
    """Main dashboard page"""
    return render_template('dashboard.html')


@app.route('/api/metrics')
def get_metrics():
    """Get usage metrics for Gemini models"""
    try:
        metrics = {}
        
        # Initialize all models as disabled
        for model in GEMINI_MODELS:
            metrics[model] = {
                "requests": 0,
                "cost": 0,
                "tokens": 0,
                "avg_latency": 0,
                "enabled": False
            }
        
        # Try to fetch data from Langfuse API
        try:
            import requests
            
            langfuse_host = os.getenv("LANGFUSE_HOST", "https://cloud.langfuse.com")
            public_key = os.getenv("LANGFUSE_PUBLIC_KEY")
            secret_key = os.getenv("LANGFUSE_SECRET_KEY")
            
            if not public_key or not secret_key:
                return jsonify({
                    "success": True,
                    "metrics": metrics,
                    "last_updated": datetime.now().isoformat(),
                    "message": "Langfuse credentials not configured"
                })
            
            # Use Langfuse API to get traces
            # Note: This is a simplified version - you may need to adjust based on actual API
            headers = {
                "Authorization": f"Bearer {secret_key}",
                "Content-Type": "application/json"
            }
            
            # For now, return placeholder data structure
            # In production, you would call Langfuse API here
            # Example: GET {langfuse_host}/api/public/traces
            
        except Exception as api_error:
            # If API call fails, return structure with note
            pass
        
        return jsonify({
            "success": True,
            "metrics": metrics,
            "last_updated": datetime.now().isoformat(),
            "note": "Connect to Langfuse API to see actual metrics"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


@app.route('/api/models')
def get_models():
    """Get list of enabled Gemini models"""
    try:
        metrics_data = get_metrics().get_json()
        if metrics_data.get("success"):
            enabled_models = [
                {
                    "name": model,
                    "display_name": model.replace("gemini-", "Gemini ").replace("-", " ").title(),
                    **metrics_data["metrics"][model]
                }
                for model in GEMINI_MODELS
                if metrics_data["metrics"][model].get("enabled", False)
            ]
            return jsonify({
                "success": True,
                "models": enabled_models
            })
        else:
            return jsonify({
                "success": False,
                "error": "Failed to fetch metrics"
            }), 500
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)

