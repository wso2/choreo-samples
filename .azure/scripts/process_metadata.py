import os
import yaml
import json
import shutil
import metadata_validator
import version_manager
from collections import defaultdict
from itertools import cycle

REPO_BASE_DIR = os.environ['BUILD_SOURCESDIRECTORY']
BUILD_STAGING_DIRECTORY = os.environ['BUILD_STAGINGDIRECTORY']
BASE_URL_FOR_THUMBNAILS = 'https://choreo-shared-choreo-samples-cdne.azureedge.net'


def collect_metadata_and_thumbnails():
    collected_data = []
    print("Starting to collect metadata and thumbnails...")

    # Iterate through directories and collect metadata from metadata files
    samples_dirnames_set = set()
    samples_dir = os.path.join(REPO_BASE_DIR, '.samples')
    for meta_file in os.listdir(samples_dir):
        meta_path = os.path.join(samples_dir, meta_file)
        
        if os.path.isfile(meta_path):
            with open(meta_path, 'r') as f:
                data = yaml.safe_load(f)

                component_path = data.get('componentPath')
                # Check if the componentPath exists
                if not metadata_validator.validate_component_path(component_path, data.get('repositoryUrl')):
                    print(f"Warning: Component path '{component_path}' does not exist. This will be excluded from index.json.")
                    continue

                component_type = data.get('componentType', '')
                build_pack = data.get('buildPack', '')

                if not metadata_validator.validate_component_type(component_type):
                    print(f"Warning: '{component_type}' is not a valid componentType for directory: {meta_file}. Excluding from index.json.")
                    continue

                if not metadata_validator.validate_build_pack(build_pack):
                    print(f"Warning: '{build_pack}' is not a valid buildPreset for directory: {meta_file}. Excluding from index.json.")
                    continue

                # check if a quick deployable sample has a valid image URL
                if 'Quick Deployable' in data.get('tags', []):
                    image_url = data.get('imageUrl')
                    if not image_url:
                        print(f"Warning: 'imageUrl' is not set for the sample: {meta_file}. Excluding from index.json.")
                        continue
                    if not metadata_validator.validate_image_url(image_url):
                        print(f"Warning: 'imageUrl' is not a valid image URL for the sample: {meta_file}. Excluding from index.json.")
                        continue

                    # Check if openapi.yaml and endpoints.yaml exist if the component type is a service
                    if component_type == 'service':
                        endpoints_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'), '.choreo/endpoints.yaml')
                        if not os.path.exists(endpoints_path):
                            raise FileNotFoundError(f"Error: endpoints.yaml not found in {component_path.lstrip('/')}")
                        # openapi.yaml is required if service type is REST
                        # Read endpoints.yaml to check if the service type is REST
                        with open(endpoints_path, 'r') as f:
                            endpoints_data = yaml.safe_load(f)
                            if endpoints_data.get('type') == 'REST':                                
                                schema_path = endpoints_data.get('schemaFilePath')
                                openapi_path = os.path.join(REPO_BASE_DIR, component_path.lstrip('/'), schema_path.lstrip('/'))
                                if not os.path.exists(openapi_path):
                                    raise FileNotFoundError(f"Error: openapi.yaml not found in {component_path.lstrip('/')}") 

                # Check if tags key exists and if it's either not set or None, assign an empty list
                if not data.get('tags'):
                    data['tags'] = []

            # Copy thumbnail to staging directory.
            thumbnail_src = os.path.join(samples_dir, data.get('thumbnailPath').lstrip('/'))
            thumbnail_dest_folder = os.path.join(BUILD_STAGING_DIRECTORY, 'icons')
            os.makedirs(thumbnail_dest_folder, exist_ok=True)
            if metadata_validator.validate_thumbnail(thumbnail_src):
                shutil.copy(thumbnail_src, thumbnail_dest_folder)
            else:
                print(f"Thumbnail not found for {thumbnail_src}")
            
            # Adjust the thumbnailPath
            data['thumbnailPath'] = BASE_URL_FOR_THUMBNAILS + data['thumbnailPath']

            samples_dirnames_set.add(component_path.lstrip('/'))
            collected_data.append(data)

    # Check if there are any directories without corresponding metadata files
    is_valid, dir_name = metadata_validator.validate_directories_for_metafiles(samples_dirnames_set)
    if not is_valid:
        print(f"Warning: Directory '{dir_name}' does not have a corresponding metadata file. This will be excluded form index.json.")

    return collected_data

def sort_samples(samples):
    # Define the priority order for types, used for strict alternation
    type_order = ["service", "web-application", "scheduled-task", "manual-task"]
    
    # Separate and Organize QD samples and the rest
    qd_samples_by_type = defaultdict(list)
    rest_samples = []

    for sample in samples:
        if "Quick Deployable" in sample.get("tags", []):
            sample_type = sample.get("type", "")
            if sample_type in type_order:
                qd_samples_by_type[sample_type].append(sample)
        else:
            rest_samples.append(sample)

    # Interleave the QD samples based on type order
    interleaved_qd_samples = []
    type_cycle = cycle(type_order)
    while any(qd_samples_by_type.values()):
      current_type = next(type_cycle)
      if qd_samples_by_type[current_type]:
          interleaved_qd_samples.append(qd_samples_by_type[current_type].pop(0))

    # Return the interleaved QD samples followed by the rest
    return interleaved_qd_samples + rest_samples

def generate_index_json(data):
    # Create index.json structure
    index_data = {
        "samples": data,
        "count": len(data)
    }

    version_file_path = BASE_URL_FOR_THUMBNAILS + '/choreo-samples-version.txt'
    try:
        index_version = version_manager.resolve_version(version_file_path)
    except Exception as e:
        print(f"Failed to resolve version from version file: {e}")
        index_version = "v0" # Fallback to default version
        print(f"Using default version: {index_version}")
    
    # Write version value to file
    with open(os.path.join(BUILD_STAGING_DIRECTORY, 'choreo-samples-version.txt'), 'w', encoding='utf-8') as f:
        f.write(index_version)
        print(f"Generated version.txt with value: {index_version}")

    with open(os.path.join(BUILD_STAGING_DIRECTORY, f"index-{index_version}.json"), 'w', encoding='utf-8') as f:
        json.dump(index_data, f, separators=(',', ':'))  # Remove whitespace to minimize file size
    print("Generated index.json")

def main():
    metadata_data = collect_metadata_and_thumbnails()
    if metadata_data:
        print(f"Collected data for {len(metadata_data)} samples.")
    else:
        print("No metadata collected!")
    sorted_metadata_data = sort_samples(metadata_data)
    generate_index_json(sorted_metadata_data)

if __name__ == '__main__':
    main()
