@REM 这里处理v8源码仓库镜像
echo =====[ Reset V8 Git ]=====
setlocal enabledelayedexpansion

set inputFile="./depot_tools/fetch_configs/v8.py"
set inputFile2="./depot_tools/metrics_utils.py"

set searchString="https://chromium.googlesource.com/v8/v8.git"
set replaceString="https://github.com/alintong-0/v8.git"

set searchString2="KNOWN_PROJECT_URLS = {"
set replaceString2="KNOWN_PROJECT_URLS = {\"https://github.com/alintong-0/v8\","

rem 用 powershell 命令读取文件并替换字符串
powershell -Command "(Get-Content %inputFile%) -replace '%searchString%', '%replaceString%' | Set-Content %inputFile%"
powershell -Command "(Get-Content %inputFile2%) -replace '%searchString2%', '%replaceString2%' | Set-Content %inputFile2%"

endlocal
pause