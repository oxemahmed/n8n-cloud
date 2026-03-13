# -----------------------------
# n8n Auto Start Script
# -----------------------------

# 1️⃣ إعداد المسار
$projectPath = "C:\Users\RDP\Desktop\n8n-cloud"

# 2️⃣ تثبيت n8n إذا لم يكن مثبت
Write-Host "Checking n8n installation..."
try {
    n8n --version | Out-Null
    Write-Host "n8n is already installed."
} catch {
    Write-Host "Installing n8n globally..."
    npm install -g n8n
}

# 3️⃣ تنزيل المشروع من GitHub
if (Test-Path $projectPath) {
    Write-Host "Project exists, pulling latest changes..."
    cd $projectPath
    git pull
} else {
    Write-Host "Cloning project from GitHub..."
    git clone https://github.com/oxemahmed/n8n-cloud.git $projectPath
    cd $projectPath
}

# 4️⃣ استرجاع workflows
$workflowFile = "$projectPath\workflows.json"
if (Test-Path $workflowFile) {
    Write-Host "Importing workflows..."
    npx n8n import:workflow --input $workflowFile
} else {
    Write-Host "No workflows.json found."
}

# 5️⃣ تشغيل Cloudflare Tunnel
Write-Host "Starting Cloudflare Tunnel..."
Start-Process "cloudflared" "tunnel --url http://localhost:5678"

# 6️⃣ تشغيل n8n
Write-Host "Starting n8n..."
npx n8n