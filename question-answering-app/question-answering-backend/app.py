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
from flask import request, Flask

from answer_generator import answer_query_with_context
from config_loader import configs
from constants import OPENAI_API_TYPE, AZURE_OPENAI_API_VERSION

openai.api_key = configs["OPENAI_API_KEY"]
openai.api_base = configs["OPENAI_API_BASE"]
openai.api_type = OPENAI_API_TYPE
openai.api_version = AZURE_OPENAI_API_VERSION

app = Flask(__name__)


@app.route('/generate_answer', methods=['POST'])
def generate_answer():
    try:
        json_body = request.json
        question = json_body.get('question')

    except Exception as e:
        logging.exception("Request is not properly formatted")
        return "Request is not properly formatted.", 400

    try:
        return {
            'answer': answer_query_with_context(question)
        }
    except Exception as e:
        logging.exception("Error generating answer.")
        return "There was an error generating the answer", 500


if __name__ == '__main__':
    app.run()
