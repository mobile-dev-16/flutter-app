import os


def collect_dart_files(output_file="dart_files.txt"):
    # Open the output file in write mode
    with open(output_file, "w", encoding="utf-8") as outfile:
        # Walk through the directory structure
        for root, _, files in os.walk("."):
            for file in files:
                if file.endswith(".dart"):
                    file_path = os.path.join(root, file)
                    # Write the file path as a comment
                    outfile.write(f"// File: {file_path}\n")
                    with open(file_path, "r", encoding="utf-8") as dart_file:
                        # Write the file content
                        outfile.write(dart_file.read())
                    # Add a line break after each file for readability
                    outfile.write("\n\n")


if __name__ == "__main__":
    collect_dart_files()
