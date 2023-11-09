import os
import yaml
import json
import shutil
import metadata_validator

REPO_BASE_DIR = os.environ['BUILD_SOURCESDIRECTORY']

def validate_metadata_and_thumbnails():
    """
    Validates the metadata and thumbnails of Choreo samples.

    This function iterates through the directories in the `.samples` directory and collects metadata from metadata files.
    It checks if the componentPath exists and if the thumbnail exists. It also checks if there are any directories without
    corresponding metadata files.
    """

    # Iterate through directories and collect metadata from metadata files
    samples_dirnames_set = set()
    samples_dir = os.path.join(REPO_BASE_DIR, '.samples')
    for meta_file in os.listdir(samples_dir):
        meta_path = os.path.join(samples_dir, meta_file)
        
        if os.path.isfile(meta_path):
            with open(meta_path, 'r') as f:
                data = yaml.safe_load(f)

                component_path = data.get('componentPath')
                repository_url = data.get('repositoryUrl')
                # Check if the componentPath exists
                if not metadata_validator.validate_component_path(component_path, repository_url):
                    raise ValueError(f"Error: Component path '{component_path}' does not exist. This will be excluded from index.json.")

                component_type = data.get('componentType', '')
                if not metadata_validator.validate_component_type(component_type):
                    raise ValueError(f"Error: '{component_type}' is not a valid component type for the sample: {meta_file}.")
                
                build_pack = data.get('buildPack', '')
                if not metadata_validator.validate_build_pack(build_pack):
                    raise ValueError(f"Error: '{build_pack}' is not a valid build pack for the sample: {meta_file}.")

            thumbnail_src = os.path.join(samples_dir, data.get('thumbnailPath').lstrip('/'))
            if not metadata_validator.validate_thumbnail(thumbnail_src):
                raise FileNotFoundError(f"Thumbnail not found in {data.get('thumbnailPath')}")

            samples_dirnames_set.add(component_path.lstrip('/'))

    # Check if there are any directories without corresponding metadata files
    is_valid, dir_name = metadata_validator.validate_directories_for_metafiles(samples_dirnames_set)
    if not is_valid:
        raise ValueError(f"Error: Directory '{dir_name}' does not have a corresponding metadata file.")

def main():
    try:
        validate_metadata_and_thumbnails()
    except (ValueError, FileNotFoundError) as e:
        print(f"Failed: {e}")
        exit(1)

if __name__ == '__main__':
    main()
