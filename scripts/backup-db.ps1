# =============================================================================
# EdTech Database Backup Script
# Backup PostgreSQL từ VPS Contabo về máy local
# Usage: .\scripts\backup-db.ps1
# =============================================================================

# --- Configuration ---
$VPS_HOST = "147.93.156.64"
$VPS_USER = "root"
$DB_NAME = "edtech"
$DB_USER = "edtech"

$LOCAL_BACKUP_DIR = "D:\EdTech\backups"
$REMOTE_TEMP_DIR = "/tmp"

$TIMESTAMP = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$BACKUP_FILENAME = "edtech_backup_${TIMESTAMP}.sql"
$REMOTE_BACKUP_PATH = "${REMOTE_TEMP_DIR}/${BACKUP_FILENAME}"
$LOCAL_BACKUP_PATH = Join-Path $LOCAL_BACKUP_DIR $BACKUP_FILENAME

# --- Functions ---

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✅ $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  ❌ $Message" -ForegroundColor Red
}

function Initialize-BackupDirectory {
    if (-not (Test-Path $LOCAL_BACKUP_DIR)) {
        New-Item -ItemType Directory -Path $LOCAL_BACKUP_DIR -Force | Out-Null
        Write-Success "Created backup directory: $LOCAL_BACKUP_DIR"
    }
}

function Invoke-RemoteDump {
    Write-Step "Dumping database on VPS..."
    
    $dumpCommand = "sudo -u postgres pg_dump -d $DB_NAME --no-owner --no-acl -f $REMOTE_BACKUP_PATH"
    ssh -o StrictHostKeyChecking=no "${VPS_USER}@${VPS_HOST}" $dumpCommand
    
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "pg_dump failed on VPS"
        exit 1
    }
    Write-Success "Database dumped to $REMOTE_BACKUP_PATH"
}

function Download-BackupFile {
    Write-Step "Downloading backup to local..."
    
    scp -o StrictHostKeyChecking=no "${VPS_USER}@${VPS_HOST}:${REMOTE_BACKUP_PATH}" $LOCAL_BACKUP_PATH
    
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Download failed"
        exit 1
    }
    
    $fileSize = (Get-Item $LOCAL_BACKUP_PATH).Length
    $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
    Write-Success "Downloaded: $LOCAL_BACKUP_PATH ($fileSizeMB MB)"
}

function Remove-RemoteTempFile {
    Write-Step "Cleaning up remote temp file..."
    
    ssh -o StrictHostKeyChecking=no "${VPS_USER}@${VPS_HOST}" "rm -f $REMOTE_BACKUP_PATH"
    Write-Success "Removed remote temp file"
}

function Remove-OldBackups {
    Write-Step "Removing old backups (keeping only latest)..."
    
    $allBackups = Get-ChildItem -Path $LOCAL_BACKUP_DIR -Filter "edtech_backup_*.sql" | 
                  Sort-Object LastWriteTime -Descending
    
    if ($allBackups.Count -gt 1) {
        $oldBackups = $allBackups | Select-Object -Skip 1
        foreach ($oldBackup in $oldBackups) {
            Remove-Item $oldBackup.FullName -Force
            Write-Host "  🗑️ Deleted: $($oldBackup.Name)" -ForegroundColor DarkGray
        }
        Write-Success "Kept only the latest backup"
    }
    else {
        Write-Success "No old backups to remove"
    }
}

# --- Main ---

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  EdTech Database Backup" -ForegroundColor Yellow
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow

Initialize-BackupDirectory
Invoke-RemoteDump
Download-BackupFile
Remove-RemoteTempFile
Remove-OldBackups

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Backup completed successfully!" -ForegroundColor Green
Write-Host "  File: $LOCAL_BACKUP_PATH" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
