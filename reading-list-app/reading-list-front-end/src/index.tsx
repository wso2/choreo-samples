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
import { Tab } from "@headlessui/react";
import { getBooks } from "./api/books/get-books";
import { Book } from "./api/books/types/book";
import groupBy from "lodash/groupBy";
import AddItem from "./components/modal/fragments/add-item";
import { deleteBooks } from "./api/books/delete-books";
import { BasicUserInfo, useAuthContext } from "@asgardeo/auth-react";
import { Dictionary } from "lodash";
import { ArrowPathIcon } from "@heroicons/react/24/solid";

export function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export default function App() {
  const [readList, setReadList] = useState<Dictionary<Book[]> | null>(null);
  const [isAddItemOpen, setIsAddItemOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const {
    signIn,
    signOut,
    getAccessToken,
    isAuthenticated,
    getBasicUserInfo,
    state,
  } = useAuthContext();
  const [isAuthLoading, setIsAuthLoading] = useState(false);
  const [signedIn, setSignedIn] = useState(false);
  const [user, setUser] = useState<BasicUserInfo | null>(null);

  const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

  useEffect(() => {
    async function signInCheck() {
      setIsAuthLoading(true);
      await sleep(2000);
      const isSignedIn = await isAuthenticated();
      setSignedIn(isSignedIn);
      setIsAuthLoading(false);
      return isSignedIn;
    }
    signInCheck().then((res) => {
      if (res) {
        getReadingList();
        getUser();
      } else {
        console.log("User has not signed in");
      }
    });
  }, []);

  async function getUser() {
    setIsLoading(true);
    const userResponse = await getBasicUserInfo();
    setUser(userResponse);
    setIsLoading(false);
  }

  async function getReadingList() {
    if (signedIn) {
      setIsLoading(true);
      const accessToken = await getAccessToken();
      getBooks(accessToken)
        .then((res) => {
          const grouped = groupBy(res.data, (item) => item.status);
          setReadList(grouped);
          setIsLoading(false);
        })
        .catch((e) => {
          console.log(e);
        });
    }
  }

  useEffect(() => {
    if (!isAddItemOpen) {
      getReadingList();
    }
  }, [isAddItemOpen]);

  const handleDelete = async (id: string) => {
    const accessToken = await getAccessToken();
    setIsLoading(true);
    await deleteBooks(accessToken, id);
    getReadingList();
    setIsLoading(false);
  };

  const handleSignIn = async () => {
    signIn()
      .then(() => {
        setSignedIn(true);
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
      <button
        className="float-right bg-black bg-opacity-20 p-2 rounded-md text-sm my-3 font-medium text-white"
        onClick={handleSignIn}
      >
        Login
      </button>
    );
  }

  return (
    <div className="header-2 w-screen h-screen overflow-hidden">
      <nav className="bg-white py-2 md:py-2">
        <div className="container px-4 mx-auto md:flex md:items-center">
          <div className="flex justify-between items-center">
            {user && (
              <a href="#" className="font-bold text-xl text-[#36d1dc]">
                {user?.orgName}
              </a>
            )}
            <button
              className="border border-solid border-gray-600 px-3 py-1 rounded text-gray-600 opacity-50 hover:opacity-75 md:hidden"
              id="navbar-toggle"
            >
              <i className="fas fa-bars"></i>
            </button>
          </div>

          <div
            className="hidden md:flex flex-col md:flex-row md:ml-auto mt-3 md:mt-0"
            id="navbar-collapse"
          >
            <button
              className="float-right bg-[#5b86e5] p-2 rounded-md text-sm my-3 font-medium text-white"
              onClick={() => signOut()}
            >
              Logout
            </button>
          </div>
        </div>
      </nav>

      <div className="py-3 md:py-6">
        <div className="container px-4 mx-auto flex justify-center">
          <div className="w-full max-w-lg px-2 py-16 sm:px-0 mb-20">
            <div className="flex justify-between">
              <p className="text-4xl text-white mb-3 font-bold">Reading List</p>
              <div className="container w-auto">
                <button
                  className="float-right bg-black bg-opacity-20 p-2 rounded-md text-sm my-3 font-medium text-white h-10"
                  onClick={() => setIsAddItemOpen(true)}
                >
                  + Add New
                </button>
                <button
                  className="float-right bg-black bg-opacity-20 p-2 rounded-md text-sm my-3 font-medium text-white w-10 h-10 mr-1"
                  onClick={() => getReadingList()}
                >
                  <ArrowPathIcon />
                </button>
              </div>
            </div>
            {readList && (
              <Tab.Group>
                <Tab.List className="flex space-x-1 rounded-xl bg-blue-900/20 p-1">
                  {Object.keys(readList).map((val) => (
                    <Tab
                      key={val}
                      className={({ selected }) =>
                        classNames(
                          "w-full rounded-lg py-2.5 text-sm font-medium leading-5 text-blue-700",
                          "ring-white ring-opacity-60 ring-offset-2 ring-offset-blue-400 focus:outline-none focus:ring-2",
                          selected
                            ? "bg-white shadow"
                            : "text-blue-100 hover:bg-white/[0.12] hover:text-white"
                        )
                      }
                    >
                      {val}
                    </Tab>
                  ))}
                </Tab.List>
                <Tab.Panels className="mt-2">
                  {Object.values(readList).map((books: Book[], idx) => (
                    <Tab.Panel
                      key={idx}
                      className={
                        isLoading
                          ? classNames(
                              "rounded-xl bg-white p-3 ring-white ring-opacity-60 ring-offset-2 ring-offset-blue-400 focus:outline-none focus:ring-2 animate-pulse"
                            )
                          : classNames(
                              "rounded-xl bg-white p-3 ring-white ring-opacity-60 ring-offset-2 ring-offset-blue-400 focus:outline-none focus:ring-2"
                            )
                      }
                    >
                      <ul>
                        {books.map((book) => (
                          <div className="flex justify-between">
                            <li
                              key={book.id}
                              className="relative rounded-md p-3"
                            >
                              <h3 className="text-sm font-medium leading-5">
                                {book.title}
                              </h3>

                              <ul className="mt-1 flex space-x-1 text-xs font-normal leading-4 text-gray-500">
                                <li>{book.author}</li>
                                <li>&middot;</li>
                              </ul>
                            </li>
                            <button
                              className="float-right bg-red-500 text-white rounded-md self-center text-xs p-2 mr-2"
                              onClick={() => handleDelete(book.id!)}
                            >
                              Delete
                            </button>
                          </div>
                        ))}
                      </ul>
                    </Tab.Panel>
                  ))}
                </Tab.Panels>
              </Tab.Group>
            )}
            <AddItem isOpen={isAddItemOpen} setIsOpen={setIsAddItemOpen} />
          </div>
        </div>
      </div>
    </div>
  );
}
