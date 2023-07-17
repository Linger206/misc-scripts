# 备份特定文件夹为压缩文件(保留近5日的备份文件), 然后打开特定网页并运行特定程序
# PowerShell v6 以下版本若路径包含中文, 需将此脚本保存为 UTF-8 BOM 格式

# 获取当前日期
$today = Get-Date -Format "yyyyMMdd"

# 定义文件夹和备份路径
$folderToBackup = "C:\Users\xxx\path\to\backup\"
$backupPath = "C:\path\to\store\backup\file\"

# 处理路径中的非ASCII字符
$folderToBackup = [System.IO.Path]::GetFullPath($folderToBackup)
$backupPath = [System.IO.Path]::GetFullPath($backupPath)

# 创建备份文件名
$backupFileName = "backup_" + $today + ".zip"
$backupFile = $backupPath + $backupFileName

# 使用 7z 命令行进行压缩
& "7z.exe" a $backupFile $folderToBackup

# 删除超过5天的备份文件
$backupFiles = Get-ChildItem -Path $backupPath -Filter "backup_*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-5) }

foreach ($file in $backupFiles) {
    Remove-Item $file.FullName -Force
}

# 使用 Vivaldi 浏览器在 app 模式中打开特定网页
$webPageUrl = "https://www.baidu.com"  # 替换为你要打开的网页 URL
Start-Process "D:\Apps\Vivaldi\Application\vivaldi.exe" "--app=$webPageUrl"

# 启动指定的 .exe 程序
$exePath = "D:\path\to\program.exe"  # 替换为你要启动的 .exe 程序的路径
Start-Process -FilePath $exePath
