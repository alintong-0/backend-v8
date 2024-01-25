set VERSION=%1

echo =====[ Init Env ]=====
mkdir C:\v8_build
copy .\replaceV8.py C:\v8_build\replaceV8.py
copy .\fixRunning.py C:\v8_build\fixRunning.py
C:
cd v8_build
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2019
set DEPOT_TOOLS_WIN_TOOLCHAIN=0

cd depot_tools
dir
cd ..
call gclient

cd depot_tools
call git reset --hard 8d16d4a
dir
cd ..
set DEPOT_TOOLS_UPDATE=0

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

@REM 这里处理v8源码仓库镜像
echo =====[ Reset V8 Git ]=====
cd .\build
dir
cd .\toolchain
dir
cd .\win
dir
cd ..\..\..\
echo =====[ Fix Python ]=====
cd ..\..\
python fixRunning.py
dir
@REM echo =====[ replace V8 File ]=====
@REM call git clone -b Branch_8.4.371.19 "https://github.com/alintong-0/v8.git" v8_temp
@REM dir
@REM python replaceV8.py
@REM dir
cd ./v8/v8
dir
echo =====[ Building V8 ]=====
call gn gen out.gn\x86.release -args="target_os=""win"" target_cpu=""x86"" v8_use_external_startup_data=false v8_enable_i18n_support=false is_debug=false v8_static_library=true is_clang=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=false"

call ninja -C out.gn\x86.release -t clean
call ninja -C out.gn\x86.release wee8

md output\v8\Lib\Win32
copy /Y out.gn\x86.release\obj\wee8.lib output\v8\Lib\Win32\
md output\v8\Inc\Blob\Win32

echo =====[ Copy To GitHub Env ]=====
D:
cd %GITHUB_WORKSPACE%
dir
xcopy C:\v8_build %GITHUB_WORKSPACE% /E /H /C /I /Q /Y
dir