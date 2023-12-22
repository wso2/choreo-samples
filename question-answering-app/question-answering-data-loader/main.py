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

import openai
import pandas as pd
import pinecone

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


def main():
    """
    Main function
    """

    pinecone_data = []

    data = pd.read_csv(config["DATA_URL"])

    try:
        # Generate data arrays to be inserted into Pinecone
        for index, row in data.iterrows():
            title, content = row
            pinecone_data.append({
                "id": title + "-" + str(index),
                "values": get_embedding(title + content),
                "metadata": {"content": content}
            })

    except Exception as e:
        logging.exception("Error generating data vectors with embeddings")
        return

    if len(pinecone_data) == 0:
        logging.error("No data found.")
        return

    # Insert data into Pinecone index
    index = pinecone.Index(config["PINECONE_INDEX_NAME"])
    index.upsert(pinecone_data)

    logging.info("Successfully inserted data into Pinecone.")


if __name__ == "__main__":
    main()
