import requests

def resolve_version(url):
    # Fetch the version number from the URL
    response = requests.get(url)
    response.raise_for_status()  # Raise an exception if the request failed

    # Remove preceding 'v' in the version number
    version_text = response.text.strip()
    if version_text.startswith('v'):
        version_text = version_text[1:]

    version = int(version_text.strip())

    # Increment the version number
    version += 1

    # If the version number is greater than 99, set it to 1
    if version > 99:
        version = 1
    print(f"Resolved version: {version}")
    return "v" + str(version)
