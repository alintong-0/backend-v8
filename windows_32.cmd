set VERSION=%1

cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2019
set DEPOT_TOOLS_WIN_TOOLCHAIN=0

call gclient

cd depot_tools
call git reset --hard 8d16d4a
cd ..
set DEPOT_TOOLS_UPDATE=0

@REM 这里处理v8源码仓库镜像
echo =====[ Reset V8 Git ]=====
setlocal enabledelayedexpansion

set inputFile="./depot_tools/fetch_configs/v8.py"
set inputFile2="./depot_tools/metrics_utils.py"
set inputFile3="./depot_tools/recipes/recipe_modules/bot_update/examples/full.py"

set searchString="https://chromium.googlesource.com/v8/v8.git"
set searchString3="https://chromium.googlesource.com/v8/v8"
set replaceString="https://github.com/alintong-0/v8.git"
set replaceString3="https://github.com/alintong-0/v8"

set searchString2="KNOWN_PROJECT_URLS = {"
set replaceString2="KNOWN_PROJECT_URLS = {\"https://github.com/alintong-0/v8\","

rem 用 powershell 命令读取文件并替换字符串
@REM powershell -Command "(Get-Content %inputFile%) -replace '%searchString%', '%replaceString%' | Set-Content %inputFile%"
powershell -Command "(Get-Content %inputFile2%) -replace '%searchString2%', '%replaceString2%' | Set-Content %inputFile2%"
@REM powershell -Command "(Get-Content %inputFile3%) -replace '%searchString3%', '%replaceString3%' | Set-Content %inputFile3%"

endlocal

mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
cd v8
call git checkout refs/tags/%VERSION%
cd test\test262\data
call git config --system core.longpaths true
call git restore *
cd ..\..\..\
call gclient sync

@REM echo =====[ Patching V8 ]=====
@REM node %GITHUB_WORKSPACE%\CRLF2LF.js %GITHUB_WORKSPACE%\patches\builtins-puerts.patches
@REM call git apply --cached --reject %GITHUB_WORKSPACE%\patches\builtins-puerts.patches
@REM call git checkout -- .

@REM issue #4
node %~dp0\node-script\do-gitpatch.js -p %GITHUB_WORKSPACE%\patches\intrin.patch

echo =====[ add ArrayBuffer_New_Without_Stl ]=====
node %~dp0\node-script\add_arraybuffer_new_without_stl.js .

echo =====[ Building V8 ]=====
D:
call gn gen out.gn\x86.release -args="target_os=""win"" target_cpu=""x86"" v8_use_external_startup_data=false v8_enable_i18n_support=false is_debug=false v8_static_library=true is_clang=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=false"

call ninja -C out.gn\x86.release -t clean
call ninja -C out.gn\x86.release wee8

md output\v8\Lib\Win32
copy /Y out.gn\x86.release\obj\wee8.lib output\v8\Lib\Win32\
md output\v8\Inc\Blob\Win32
