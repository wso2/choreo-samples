"""
 Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.

 WSO2 LLC. licenses this file to you under the Apache License,
 Version 2.0 (the "License"); you may not use this file except
 in compliance with the License.
 You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied. See the License for the
 specific language governing permissions and limitations
 under the License.
"""

import logging

import gspread
import openai
import pinecone
from oauth2client.service_account import ServiceAccountCredentials

from config_loader import load_configs
from constants import *

logging.basicConfig(level=logging.INFO)

# Load configs
config = load_configs()

# Initialize OpenAI client
openai.api_key = config["OPENAI_API_KEY"]
openai.api_base = config["OPENAI_API_BASE"]
openai.api_type = OPENAI_API_TYPE
openai.api_version = OPENAI_API_VERSION

# Initialize Pinecone client
pinecone.init(api_key=config["PINECONE_API_KEY"], environment=config["PINECONE_ENVIRONMENT"])


def get_embedding(text):
    """
    Function to get embeddings using OpenAI
    """
    result = openai.Embedding.create(
        engine=config["OPENAI_EMBEDDING_MODEL"],
        input=text
    )
    return result["data"][0]["embedding"]


def read_data_from_google_sheets(sheet_id, sheet_name):
    """
    Function to read data from Google Sheets
    """
    try:
        # Authorize Google Sheets client
        scope = ['https://www.googleapis.com/auth/spreadsheets',
                 "https://www.googleapis.com/auth/drive"]
        credentials = ServiceAccountCredentials.from_json_keyfile_name(GS_CREDENTIALS_PATH, scope)
        gsclient = gspread.authorize(credentials)

        # Open the Google Sheet and read the data
        sh = gsclient.open_by_key(sheet_id)
        worksheet = sh.worksheet(sheet_name)
        values = worksheet.get_all_values()[1:]  # Skip the header

    except Exception as e:
        logging.exception("Error reading data from the google sheet and generating embeddings")
        return

    try:
        # Generate data arrays to be inserted into Pinecone
        data = []
        for row in values:
            title, content = row
            data.append({
                "id": title,
                "values": get_embedding(content),
                "metadata": {"content": content}
            })

        return data

    except Exception as e:
        logging.exception("Error generating data vectors with embeddings")
        return


def main():
    """
    Main function
    """
    # Read data from Google Sheets
    data = read_data_from_google_sheets(config["SHEET_ID"], config["WORKSHEET_NAME"])

    if data is None:
        return

    if len(data) == 0:
        logging.error("No data found in the Google Sheet.")
        return

    # Insert data into Pinecone index
    index = pinecone.Index(config["PINECONE_INDEX_NAME"])
    index.upsert(data)

    logging.info("Successfully inserted data into Pinecone.")


if __name__ == "__main__":
    main()
