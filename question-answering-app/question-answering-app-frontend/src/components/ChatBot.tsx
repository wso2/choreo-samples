// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import React, { useState, useEffect } from "react";
import BotMessage from "./BotMessage";
import UserMessage from "./UserMessage";
import Messages from "./Messages";
import Input from "./Input";
import { Header } from "./Header";
import { useAuthContext } from "@asgardeo/auth-react";
import { getAnswer, getChatbotGreeting } from "../api/chat";

export default function ChatBot() {
  const [messages, setMessages] = useState<any>([]);

  const { getAccessToken } = useAuthContext();

  useEffect(() => {
    async function loadWelcomeMessage() {
      setMessages([
        <BotMessage key="0" fetchMessage={async () => getChatbotGreeting()} />,
      ]);
    }
    loadWelcomeMessage();
  }, []);

  async function send(text: string) {
    const accessToken = await getAccessToken();
    const newMessages = messages.concat(
      <UserMessage key={messages.length + 1} text={text} />,
      <BotMessage
        key={messages.length + 2}
        fetchMessage={async () => await getAnswer(accessToken, text)}
      />
    );
    setMessages(newMessages);
  }

  return (
    <div className="chatbot-container">
      <div className="chatbot">
        <Header />
        <Messages messages={messages} />
        <Input onSend={send} />
      </div>
    </div>
  );
}
