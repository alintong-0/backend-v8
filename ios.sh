VERSION=$1
[ -z "$GITHUB_WORKSPACE" ] && GITHUB_WORKSPACE="$( cd "$( dirname "$0" )"/.. && pwd )"

cd ~
echo "=====[ Getting Depot Tools ]====="	
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
cd depot_tools
git reset --hard 8d16d4a
cd ..
export DEPOT_TOOLS_UPDATE=0
export PATH=$(pwd)/depot_tools:$PATH
gclient


# 处理v8源码仓库镜像
echo "=====[ Reset V8 Git ]====="
inputFile="./depot_tools/fetch_configs/v8.py"
inputFile2="./depot_tools/metrics_utils.py"
inputFile3="./depot_tools/recipes/recipe_modules/bot_update/examples/full.py"

searchString="https://chromium.googlesource.com/v8/v8.git"
searchString3="https://chromium.googlesource.com/v8/v8"
replaceString="https://github.com/alintong-0/v8.git"
replaceString3="https://github.com/alintong-0/v8"

searchString2="KNOWN_PROJECT_URLS = {"
replaceString2="KNOWN_PROJECT_URLS = {\"https://github.com/alintong-0/v8\","

# 使用sed命令替换文件中的字符串
sed -i "s|$searchString|$replaceString|g" "$inputFile"
sed -i "s|$searchString2|$replaceString2|g" "$inputFile2"
sed -i "s|$searchString3|$replaceString3|g" "$inputFile3"

mkdir v8
cd v8

echo "=====[ Fetching V8 ]====="
fetch v8
echo "target_os = ['ios']" >> .gclient
cd ~/v8/v8
git checkout refs/tags/$VERSION
gclient sync

# echo "=====[ Patching V8 ]====="
# git apply --cached $GITHUB_WORKSPACE/patches/builtins-puerts.patches
# git checkout -- .

echo "=====[ add ArrayBuffer_New_Without_Stl ]====="
node $GITHUB_WORKSPACE/node-script/add_arraybuffer_new_without_stl.js .

echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py arm64.release -vv -- '
v8_use_external_startup_data = false
v8_use_snapshot = true
v8_enable_i18n_support = false
is_debug = false
v8_static_library = true
ios_enable_code_signing = false
target_os = "ios"
target_cpu = "arm64"
v8_enable_pointer_compression = false
libcxx_abi_unstable = false
'
ninja -C out.gn/arm64.release -t clean
ninja -C out.gn/arm64.release wee8
strip -S out.gn/arm64.release/obj/libwee8.a

mkdir -p output/v8/Lib/iOS/arm64
cp out.gn/arm64.release/obj/libwee8.a output/v8/Lib/iOS/arm64/
mkdir -p output/v8/Inc/Blob/iOS/arm64
