#!/bin/bash
echo "Ì∫Ä Setting up ERPNext..."

# Pull latest image
docker pull devpro2375/my-erpnext:latest

# Start all services
docker compose -f docker-compose.team.yml up -d

echo ""
echo "‚è≥ Creating site (wait 2-3 minutes)..."
echo "Check status: docker compose -f docker-compose.team.yml logs -f create-site"
echo ""
sleep 120

docker compose -f docker-compose.team.yml logs create-site | tail -20

echo ""
echo "‚úÖ Setup complete!"
echo "Ìºê Access: http://localhost:8080"
echo "Ì±§ Username: Administrator"
echo "Ì¥ë Password: admin"
