import os
import shutil

source_directory = "./v8_temp"
destination_directory = "./v8/v8/"

current_directory = os.path.abspath(os.path.dirname(__file__))

print("now run root : ", current_directory)

for root, dirs, files in os.walk(source_directory):
    for file_name in files:
        source_file_path = os.path.join(root, file_name)
        destination_file_path = os.path.join(destination_directory, file_name)


        if os.path.exists(destination_file_path):
            print(f"replace file~~~{file_name}")
            shutil.copy2(source_file_path, destination_file_path)

print("all done!!")
