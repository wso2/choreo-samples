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

import openai
import pinecone
import tiktoken

from config_loader import configs
from constants import ENCODING, SEPARATOR, MAX_SECTION_LEN

pinecone.init(api_key=configs["PINECONE_API_KEY"], environment=configs["PINECONE_ENVIRONMENT"])


def get_embedding(text):
    result = openai.Embedding.create(
        engine=configs["OPENAI_EMBEDDING_MODEL"],
        input=text
    )

    return result["data"][0]["embedding"]


def fetch_document_sections(query, limit=5):
    """
    Find the query embedding for the supplied query, and compare it against all of the pre-calculated document embeddings
    to find the most relevant sections.
    """

    index = pinecone.Index(configs["PINECONE_INDEX_NAME"])
    query_embedding = get_embedding(query)
    documents = index.query(
        top_k=limit,
        include_metadata=True,
        vector=query_embedding
    )
    return documents["matches"]


def construct_prompt(question) -> str:
    """
    Fetch relevant document sections and construct a prompt to answer the question using the LLM.
    """
    most_relevant_document_sections = fetch_document_sections(question)

    chosen_sections = []
    chosen_sections_len = 0

    encoding = tiktoken.get_encoding(ENCODING)

    for document_section in most_relevant_document_sections:
        content = document_section["metadata"]["content"].replace("\n", " ")
        chosen_sections_len += len(encoding.encode(content + SEPARATOR))
        if chosen_sections_len > MAX_SECTION_LEN:
            break

        chosen_sections.append(content)

    instruction_prompt = "Answer the question as truthfully and descriptively as possible using the provided " \
                         "context, and if the answer is not contained within the text below, say \"Sorry, " \
                         "I didn't understand the question. If it is about Choreo, could you please rephrase it " \
                         "and try again?\". "

    return f"{instruction_prompt}\n{SEPARATOR.join(chosen_sections)}\n\nQ: {question}\nA:"


def answer_query_with_context(query):
    """
    Answer the query using the LLM.
    """
    prompt = construct_prompt(query)
    response = openai.ChatCompletion.create(
        engine=configs["OPENAI_CHAT_MODEL"],
        messages=[{"role": "system", "content": prompt}]
    )
    return response["choices"][0]["message"]["content"].strip()
