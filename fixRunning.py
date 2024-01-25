# Open the file and read its content
file_path = "./v8/v8/build/toolchain/win/tool_wrapper.py"  # Replace with the path to the file you want to work with
search_string = "if (not line.startswith('   Creating library ') and"
search_string2 = "if not line.startswith(' Assembling: '):"
new_line = "line = line.decode('utf8')"

with open(file_path, "r") as file:
    lines = file.readlines()

# Find the search string and add a new line after it
with open(file_path, "w") as file:
    found = False
    for line in lines:
        print(line)
        if search_string in line:
            found = True
            print("Successfully added a new line.")
            file.write(line.replace(search_string,new_line) + "\n")  # Write the new line after it
            file.write(line)  # Write the line containing the search string
        elif search_string2 in line:
            found = True
            print("Successfully added a new line.")
            file.write(line.replace(search_string2,new_line) + "\n")  # Write the new line after it
            file.write(line)  # Write the line containing the search string
        else:
            file.write(line)  # Write the original line

if not found:
    print("Search string not found.")
