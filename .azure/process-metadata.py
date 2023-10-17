import os
import yaml
import json
import shutil

REPO_BASE_DIR = '..' 
BUILD_STAGING_DIRECTORY = os.environ['Build.StagingDirectory']  # Azure DevOps pipeline environment variable

def collect_metadata_and_thumbnails():
    collected_data = []

    # Iterate through directories and collect metadata from metadata.yaml
    for directory in os.listdir(REPO_BASE_DIR):
        dir_path = os.path.join(REPO_BASE_DIR, directory)
        metadata_file = os.path.join(dir_path, 'metadata.yaml')
        
        if os.path.isdir(dir_path) and os.path.exists(metadata_file):
            with open(metadata_file, 'r') as f:
                data = yaml.safe_load(f)
                collected_data.append(data)

            # Copy thumbnail to staging directory while preserving folder name
            thumbnail_src = os.path.join(dir_path, data.get('thumbnailPath').split('/')[-1])
            thumbnail_dest_folder = os.path.join(BUILD_STAGING_DIRECTORY, directory)
            os.makedirs(thumbnail_dest_folder, exist_ok=True)
            if os.path.exists(thumbnail_src):
                shutil.copy(thumbnail_src, thumbnail_dest_folder)

    return collected_data

def generate_index_json(data):
    # Create index.json structure
    index_data = {
        "samples": data,
        "count": len(data)
    }

    with open(os.path.join(BUILD_STAGING_DIRECTORY, 'index.json'), 'w') as f:
        json.dump(index_data, f, indent=2)

def main():
    metadata_data = collect_metadata_and_thumbnails()
    generate_index_json(metadata_data)

if __name__ == '__main__':
    main()
