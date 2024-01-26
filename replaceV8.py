import os
import shutil

source_directory = "./v8_temp/src/"
destination_directory = "./v8/v8/src/"

replaceFileList = [
    "ast/ast.h",
    "builtins/builtins-definitions.h",
    "builtins/builtins-object.cc",
    "debug/debug-evaluate.cc",
    "init/bootstrapper.cc",
    "objects/objects.h",
    "init/v8.h",
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