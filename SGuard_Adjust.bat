@echo off
chcp 65001 >nul
title SGuard 优先级与CPU绑定设置
echo 正在以管理员身份启动 PowerShell...

:: 自动提权
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: 执行 PowerShell 脚本逻辑
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Write-Host '正在查找 SGuardSvc64.exe...'; ^
$svc = Get-Process -Name 'SGuardSvc64' -ErrorAction SilentlyContinue; ^
if ($svc) { ^
    Write-Host '找到 SGuardSvc64.exe (PID:' $svc.Id ')'; ^
    $svc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle; ^
    Write-Host '优先级已设为低'; ^
} else {Write-Host '未找到 SGuardSvc64.exe';} ^
Write-Host ''; ^
Write-Host '正在查找 SGuard64.exe...'; ^
$app = Get-Process -Name 'SGuard64' -ErrorAction SilentlyContinue; ^
if ($app) { ^
    Write-Host '找到 SGuard64.exe (PID:' $app.Id ')'; ^
    $mask = 1073741824; ^
    $app.ProcessorAffinity = $mask; ^
    Write-Host '已将 SGuard64.exe 绑定到 CPU 31 (掩码 1073741824)'; ^
} else {Write-Host '未找到 SGuard64.exe';} ^
Write-Host ''; ^
Write-Host '全部操作已完成。'; pause"
