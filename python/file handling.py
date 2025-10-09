import os
import shutil

def create_file(filename, content=""):
    try:
        with open(filename, 'w') as f:
            f.write(content)
        print(f"✅ File created: {filename}")
    except Exception as e:
        print(f"❌ Error creating file: {e}")

def read_file(filename):
    try:
        with open(filename, 'r') as f:
            content = f.read()
        print(f"📄 Contents of {filename}:\n{content}")
    except FileNotFoundError:
        print("❌ File not found.")
    except Exception as e:
        print(f"❌ Error reading file: {e}")

def append_to_file(filename, content):
    try:
        with open(filename, 'a') as f:
            f.write(content)
        print(f"✍️ Appended to file: {filename}")
    except Exception as e:
        print(f"❌ Error appending to file: {e}")

def write_binary_file(filename, data: bytes):
    try:
        with open(filename, 'wb') as f:
            f.write(data)
        print(f"📦 Binary data written to {filename}")
    except Exception as e:
        print(f"❌ Error writing binary file: {e}")

def read_binary_file(filename):
    try:
        with open(filename, 'rb') as f:
            data = f.read()
        print(f"📦 Binary data read from {filename}: {data}")
    except Exception as e:
        print(f"❌ Error reading binary file: {e}")

def file_exists(filename):
    exists = os.path.exists(filename)
    print(f"🔍 File '{filename}' exists: {exists}")
    return exists

def rename_file(old_name, new_name):
    try:
        os.rename(old_name, new_name)
        print(f"📁 Renamed '{old_name}' to '{new_name}'")
    except Exception as e:
        print(f"❌ Error renaming file: {e}")

def delete_file(filename):
    try:
        os.remove(filename)
        print(f"🗑️ Deleted file: {filename}")
    except FileNotFoundError:
        print("❌ File not found.")
    except Exception as e:
        print(f"❌ Error deleting file: {e}")

def create_directory(dirname):
    try:
        os.makedirs(dirname, exist_ok=True)
        print(f"📂 Directory created: {dirname}")
    except Exception as e:
        print(f"❌ Error creating directory: {e}")

def list_directory(path="."):
    try:
        contents = os.listdir(path)
        print(f"📁 Contents of directory '{path}': {contents}")
    except Exception as e:
        print(f"❌ Error listing directory: {e}")

def delete_directory(dirname):
    try:
        shutil.rmtree(dirname)
        print(f"🗑️ Directory deleted: {dirname}")
    except Exception as e:
        print(f"❌ Error deleting directory: {e}")

# === DEMO USAGE ===
if __name__ == "__main__":
    filename = "example.txt"

    create_file(filename, "Hello, world!\n")
    append_to_file(filename, "This is a new line.\n")
    read_file(filename)

    file_exists(filename)
    rename_file(filename, "renamed_example.txt")
    read_file("renamed_example.txt")

    write_binary_file("binary.dat", b'\x00\x01\x02hello')
    read_binary_file("binary.dat")

    create_directory("test_folder")
    list_directory("test_folder")
    create_file("test_folder/sample.txt", "Inside folder.")
    list_directory("test_folder")

    delete_file("binary.dat")
    delete_file("renamed_example.txt")
    delete_directory("test_folder")
