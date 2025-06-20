# Developer Essentials

## Intent: Setup a Git repo and push code to GitHub
**Command:**
```
git init
git remote add origin https://github.com/username/repo.git
git add .
git commit -m 'Initial commit'
git push -u origin master
```
**Explanation:** Initializes a local Git repo, links to remote, commits files, and pushes to GitHub.

## Intent: Install Node.js on Ubuntu
**Command:**
```
sudo apt update
sudo apt install nodejs
sudo apt install npm
```
**Explanation:** Updates apt repo and installs Node.js and npm.

# Debugging Templates

## Intent: Fix permission denied error in shell
**Command:**
```
chmod +x script.sh
```
**Explanation:** Makes the script executable by adding execute permissions.

# Security & Permissions

## Intent: Find and kill process running on port 3000
**Command:**
```
lsof -i :3000
kill -9 <PID>
```
**Explanation:** Lists process using port 3000 and kills it using its PID.

