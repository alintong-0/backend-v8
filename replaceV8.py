import os
import shutil

source_directory = "./v8_temp/"
destination_directory = "./v8/v8/"

replaceFileList = [
    "src/ast/ast.h",
    "src/ast/ast.cc",
    "src/d8/d8.h",
    "src/d8/d8.cc",
    "include/v8.h",
]

for file_path in replaceFileList:
    source_file = os.path.join(source_directory, file_path)
    destination_file = os.path.join(destination_directory, file_path)

    try:
        shutil.copy2(source_file, destination_file)
        print(f'Successfully replaced {source_file} with {destination_file}')
    except FileNotFoundError:
        print(f'File not found: {source_file}')
    except Exception as e:
        print(f'Error while replacing {source_file}: {str(e)}')