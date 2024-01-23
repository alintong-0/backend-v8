import os
import shutil

# 定义两个文件目录的路径
source_directory = "./v8_temp"
destination_directory = "./v8"

# 遍历源文件目录
for root, dirs, files in os.walk(source_directory):
    for file_name in files:
        source_file_path = os.path.join(root, file_name)
        destination_file_path = os.path.join(destination_directory, file_name)

        # 检查目标文件是否存在，如果存在则替换
        if os.path.exists(destination_file_path):
            print(f"replace file~~~{file_name}")
            shutil.copy2(source_file_path, destination_file_path)

print("all done!!")
