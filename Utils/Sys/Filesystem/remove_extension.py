import os

def remove_extension(directory, extension=".!qB"):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(extension):
                old_file_path = os.path.join(root, file)
                new_file_path = os.path.join(root, file[:-len(extension)])
                os.rename(old_file_path, new_file_path)
                print(f"Renamed: {old_file_path} -> {new_file_path}")

if __name__ == "__main__":
    directory = "/Volumes/DATA14/Misc/Incoming"
    remove_extension(directory)