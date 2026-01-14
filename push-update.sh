#!/bin/bash
echo "Enter version (e.g., v1.1) or press Enter for auto: "
read VERSION

if [ -z "$VERSION" ]; then
  VERSION="v$(date '+%Y%m%d-%H%M')"
fi

echo "Ì≥¶ Creating version $VERSION..."

# Get backend container name
BACKEND_CONTAINER=$(docker ps --filter "name=backend" --format "{{.Names}}" | head -1)

if [ -z "$BACKEND_CONTAINER" ]; then
  echo "‚ùå Backend container not running!"
  exit 1
fi

# Commit running container
docker commit $BACKEND_CONTAINER devpro2375/my-erpnext:$VERSION
docker tag devpro2375/my-erpnext:$VERSION devpro2375/my-erpnext:latest

echo "Ì≥§ Pushing to Docker Hub..."
docker push devpro2375/my-erpnext:$VERSION
docker push devpro2375/my-erpnext:latest

# Database backup
echo "Ì≤æ Creating database backup..."
docker compose -f pwd.yml exec -T backend bench --site frontend backup --with-files
mkdir -p backups
docker compose -f pwd.yml cp backend:/home/frappe/frappe-bench/sites/frontend/private/backups/. ./backups/

# Update README
sed -i "s/- \*\*Version:\*\*.*/- **Version:** $VERSION/" README.md
sed -i "s/- \*\*Last Updated:\*\*.*/- **Last Updated:** $(date '+%d-%m-%Y')/" README.md
sed -i "/## Version History/a - $VERSION ($(date '+%d-%m-%Y')) - Update" README.md

# Git push
git add README.md
git commit -m "Update to $VERSION"
git push

echo ""
echo "‚úÖ Version $VERSION pushed successfully!"
echo ""
echo "Ì≥ã Team update command:"
echo "   docker pull devpro2375/my-erpnext:latest && docker compose -f docker-compose.team.yml up -d"
echo ""
echo "Ì≥¶ Latest backup: $(ls -t backups/*.sql.gz | head -1)"
echo "‚ö†Ô∏è  Upload backup to Google Drive if needed"
