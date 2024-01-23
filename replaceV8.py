def search_and_replace(file_path, search_string, replace_string):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
        with open(file_path, 'w') as file:
            for line in lines:
                updated_line = line.replace(search_string, replace_string)
                file.write(updated_line)
        
        print("done!")
    
    except FileNotFoundError:
        print("file not found")

filePath = "./depot_tools/git_cache.py"
searchString="gclient_utils.CheckCallAndFilter([self.git_exe] + cmd, **kwargs)"
replaceString="(lambda cmd : gclient_utils.CheckCallAndFilter([self.git_exe] + cmd.replace('https://chromium.googlesource.com/v8/v8.git','https://github.com/alintong-0/v8.git'), **kwargs) if 'https://chromium.googlesource.com/v8/v8.git' in cmd else gclient_utils.CheckCallAndFilter([self.git_exe] + cmd, **kwargs))()"

search_and_replace(filePath, searchString, replaceString)