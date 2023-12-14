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

import React, { useEffect, useState } from "react";
import { useAuthContext } from "@asgardeo/auth-react";
import ChatBot from "./components/ChatBot";

export default function App() {
  const { signIn, signOut, isAuthenticated } = useAuthContext();
  const [isAuthLoading, setIsAuthLoading] = useState(false);
  const [signedIn, setSignedIn] = useState(false);

  const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

  useEffect(() => {
    async function signInCheck() {
      setIsAuthLoading(true);
      await sleep(2000);
      const isSignedIn = await isAuthenticated();
      setSignedIn(isSignedIn);
      setIsAuthLoading(false);
    }
    signInCheck();
  }, []);

  const handleSignIn = () => {
    setIsAuthLoading(true);
    signIn()
      .then(() => {
        setSignedIn(true);
        setIsAuthLoading(false);
      })
      .catch((e) => {
        console.log(e);
      });
  };

  if (isAuthLoading) {
    return <div className="animate-spin h-5 w-5 text-white">.</div>;
  }

  if (!signedIn) {
    return (
      <div className="content">
        <h1 className="header-title">Choreo Q&A Bot</h1>
        <h4 className="header-description">
          Sample demo of a Q&A chatbot for&nbsp;
          <a
            href="https://wso2.com/choreo/docs/"
            target="_blank"
            rel="noreferrer noopener"
          >
            Choreo documentation
          </a>
          .
        </h4>
        <button
          className="btn primary"
          onClick={() => {
            handleSignIn();
          }}
        >
          Login
        </button>
      </div>
    );
  }

  return (
    <div className="content">
      <ChatBot />
      <button
        className="btn primary mt-4"
        onClick={() => {
          signOut();
        }}
      >
        Logout
      </button>
    </div>
  );
}
