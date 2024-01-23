import os
import shutil

source_directory = "./v8_temp/src"
destination_directory = "./v8/v8/src"

current_directory = os.path.abspath(os.path.dirname(__file__))

print("now run root : ", current_directory)

def recursive_replace(src_dir, dest_dir):
    for item in os.listdir(src_dir):
        src_item = os.path.join(src_dir, item)
        dest_item = os.path.join(dest_dir, item)

        if os.path.isdir(src_item):
            if not os.path.exists(dest_item):
                os.makedirs(dest_item)
            recursive_replace(src_item, dest_item)
        else:
            print(f"replace file~~~{src_item}")
            shutil.copy2(src_item, dest_item)


recursive_replace(source_directory, destination_directory)
print("all done!!")
