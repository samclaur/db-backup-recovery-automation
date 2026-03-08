 =============================================
 SQL Server Backup Automation Script
 Author: Samuel McLaurin
 =============================================

 --- CONFIGURATION ---
$ServerInstance  = "localhost"
$DatabaseName    = "InventoryDB"
$BackupRoot      = "C:\SQLBackups"
$LogFile         = "$BackupRoot\backup_log.txt"
$Timestamp       = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile      = "$BackupRoot\$DatabaseName`_$Timestamp.bak"

 --- CREATE BACKUP DIRECTORY IF NOT EXISTS ---
If (!(Test-Path $BackupRoot)) {
    New-Item -ItemType Directory -Path $BackupRoot | Out-Null
}

 --- PERFORM FULL BACKUP ---
Try {
    $Query = @"
    BACKUP DATABASE [$DatabaseName]
    TO DISK = N'$BackupFile'
    WITH FORMAT, INIT,
    NAME = N'$DatabaseName - Full Backup',
    STATS = 10;
"@

    Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $Query
    $Message = "$(Get-Date) | SUCCESS | Backup: $BackupFile"
    Write-Host $Message -ForegroundColor Green

} Catch {
    $Message = "$(Get-Date) | FAILED  | Error: $_"
    Write-Host $Message -ForegroundColor Red
}

 --- WRITE TO LOG ---
Add-Content -Path $LogFile -Value $Message
