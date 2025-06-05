#!/usr/bin/env python3
"""
Script para configurar Bukeer en Coolify usando la API
Requiere que ya tengas:
1. Usuario creado en Coolify Dashboard
2. Token API generado desde Settings > API Tokens
"""

import requests
import json
import os
from typing import Dict, Any

class CoolifyAPI:
    def __init__(self, base_url: str, api_token: str):
        self.base_url = base_url.rstrip('/')
        self.api_token = api_token
        self.headers = {
            'Authorization': f'Bearer {api_token}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    
    def test_connection(self) -> Dict[str, Any]:
        """Test API connection"""
        try:
            response = requests.get(f"{self.base_url}/api/health", headers=self.headers)
            return {"success": True, "status": response.status_code, "data": response.text}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def get_servers(self) -> Dict[str, Any]:
        """Get list of servers"""
        try:
            response = requests.get(f"{self.base_url}/api/v1/servers", headers=self.headers)
            if response.status_code == 200:
                return {"success": True, "data": response.json()}
            else:
                return {"success": False, "status": response.status_code, "error": response.text}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def create_project(self, name: str, description: str = "") -> Dict[str, Any]:
        """Create a new project"""
        data = {
            "name": name,
            "description": description
        }
        try:
            response = requests.post(f"{self.base_url}/api/v1/projects", 
                                   headers=self.headers, json=data)
            if response.status_code in [200, 201]:
                return {"success": True, "data": response.json()}
            else:
                return {"success": False, "status": response.status_code, "error": response.text}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def create_application(self, project_id: str, config: Dict[str, Any]) -> Dict[str, Any]:
        """Create application in project"""
        try:
            response = requests.post(f"{self.base_url}/api/v1/projects/{project_id}/applications", 
                                   headers=self.headers, json=config)
            if response.status_code in [200, 201]:
                return {"success": True, "data": response.json()}
            else:
                return {"success": False, "status": response.status_code, "error": response.text}
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def deploy_application(self, app_id: str) -> Dict[str, Any]:
        """Deploy application"""
        try:
            response = requests.post(f"{self.base_url}/api/v1/applications/{app_id}/deploy", 
                                   headers=self.headers)
            if response.status_code in [200, 201]:
                return {"success": True, "data": response.json()}
            else:
                return {"success": False, "status": response.status_code, "error": response.text}
        except Exception as e:
            return {"success": False, "error": str(e)}

def deploy_bukeer():
    """Deploy Bukeer application to Coolify"""
    
    # Configuración
    COOLIFY_URL = "http://5.161.217.217:8000"
    API_TOKEN = input("Ingresa tu Coolify API Token: ").strip()
    
    if not API_TOKEN:
        print("❌ Token API requerido")
        return
    
    coolify = CoolifyAPI(COOLIFY_URL, API_TOKEN)
    
    # Test connection
    print("🔍 Probando conexión...")
    health = coolify.test_connection()
    if not health["success"]:
        print(f"❌ Error de conexión: {health['error']}")
        return
    print("✅ Conexión exitosa")
    
    # Get servers
    print("📡 Obteniendo servidores...")
    servers = coolify.get_servers()
    if not servers["success"]:
        print(f"❌ Error obteniendo servidores: {servers.get('error', 'Unknown')}")
        return
    
    print(f"✅ Servidores encontrados: {len(servers['data'])}")
    
    # Create project
    print("📁 Creando proyecto Bukeer...")
    project = coolify.create_project(
        name="bukeer",
        description="Bukeer Travel Management Platform"
    )
    
    if not project["success"]:
        print(f"❌ Error creando proyecto: {project.get('error', 'Unknown')}")
        return
    
    project_id = project["data"]["id"]
    print(f"✅ Proyecto creado: {project_id}")
    
    # Application configuration
    app_config = {
        "name": "bukeer-app",
        "description": "Bukeer Flutter Web Application",
        "git_repository": "https://github.com/weppa-cloud/bukeer-flutter.git",
        "git_branch": "main",
        "build_pack": "dockerfile",
        "dockerfile_location": "Dockerfile.coolify",
        "publish_directory": "/",
        "port": 80,
        "environment_variables": {
            "FLUTTER_ENV": "production",
            "SUPABASE_URL": "https://wzlxbpicdcdvxvdcvgas.supabase.co",
            "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM0Njk4MDIsImV4cCI6MjA0OTA0NTgwMn0.uasg6bM_y1C3f3HRR0q8OVpO7oXOtdpNQf9JXbBCkUw"
        }
    }
    
    # Create application
    print("🚀 Creando aplicación...")
    app_result = coolify.create_application(project_id, app_config)
    
    if not app_result["success"]:
        print(f"❌ Error creando aplicación: {app_result.get('error', 'Unknown')}")
        return
    
    app_id = app_result["data"]["id"]
    print(f"✅ Aplicación creada: {app_id}")
    
    # Deploy application
    print("🔄 Iniciando deployment...")
    deploy_result = coolify.deploy_application(app_id)
    
    if not deploy_result["success"]:
        print(f"❌ Error en deployment: {deploy_result.get('error', 'Unknown')}")
        return
    
    print("✅ Deployment iniciado exitosamente!")
    print(f"🌐 Monitorea el progreso en: {COOLIFY_URL}/projects/{project_id}")
    
    return {
        "project_id": project_id,
        "app_id": app_id,
        "coolify_url": COOLIFY_URL
    }

if __name__ == "__main__":
    print("🚀 BUKEER COOLIFY DEPLOYMENT")
    print("=" * 50)
    print()
    print("📋 REQUISITOS:")
    print("1. Usuario creado en Coolify Dashboard")
    print("2. API Token generado desde Settings > API Tokens")
    print()
    
    confirm = input("¿Continuar con el deployment? (y/N): ").strip().lower()
    if confirm != 'y':
        print("❌ Deployment cancelado")
        exit(0)
    
    result = deploy_bukeer()
    if result:
        print("\n🎉 DEPLOYMENT COMPLETADO!")
        print(f"Project ID: {result['project_id']}")
        print(f"App ID: {result['app_id']}")
        print(f"Dashboard: {result['coolify_url']}")