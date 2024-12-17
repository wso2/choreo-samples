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

import Cookies from 'js-cookie';
import React, { useEffect, useState } from "react";
import { Tab } from "@headlessui/react";
import { getBooks } from "./api/books/get-books";
import { Book } from "./api/books/types/book";
import groupBy from "lodash/groupBy";
import AddItem from "./components/modal/fragments/add-item";
import { deleteBooks } from "./api/books/delete-books";
import { Dictionary } from "lodash";
import { ArrowPathIcon } from "@heroicons/react/24/solid";
import { toast } from 'react-toastify';

export function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export default function App() {
  const [readList, setReadList] = useState<Dictionary<Book[]> | null>(null);
  const [isAddItemOpen, setIsAddItemOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isAuthLoading, setIsAuthLoading] = useState(true);
  const [signedIn, setSignedIn] = useState(false);
  const [user, setUser] = useState<any>(null);

  useEffect(() => {
    if (Cookies.get('userinfo')) {
      // We are here after a login
      const userInfoCookie = Cookies.get('userinfo')
      sessionStorage.setItem("userInfo", userInfoCookie);
      Cookies.remove('userinfo');
      var userInfo = JSON.parse(atob(userInfoCookie));
      setSignedIn(true);
      setUser(userInfo);
    } else if (sessionStorage.getItem("userInfo")) {
      // We have already logged in
      var userInfo = JSON.parse(atob(sessionStorage.getItem("userInfo")!));
      setSignedIn(true);
      setUser(userInfo);
    } else {
      console.log("User is not signed in");
    }
    setIsAuthLoading(false);
  }, []);

  useEffect(() => {
    // Handle errors from Managed Authentication
    const errorCode = new URLSearchParams(window.location.search).get('code');
    const errorMessage = new URLSearchParams(window.location.search).get('message');
    if (errorCode) {
      toast.error(<>
        <p className="text-[16px] font-bold text-slate-800">Something went wrong !</p>
        <p className="text-[13px] text-slate-400 mt-1">Error Code : {errorCode}<br />Error Description: {errorMessage}</p>
      </>);    
    }
  }, []);

  useEffect(() => {
    getReadingList();
  }, [signedIn]);

  async function getReadingList() {
    if (signedIn) {
      setIsLoading(true);
      getBooks()
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
    setIsLoading(true);
    await deleteBooks(id);
    getReadingList();
    setIsLoading(false);
  };

  if (isAuthLoading) {
    return <div className="animate-spin h-5 w-5 text-white">.</div>;
  }

  if (!signedIn) {
    return (
      <button
        className="float-right bg-black bg-opacity-20 p-2 rounded-md text-sm my-3 font-medium text-white"
        onClick={() => { window.location.href = "/auth/login" }}
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
                {user?.org_name}
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
              onClick={() => {
                sessionStorage.removeItem("userInfo");
                window.location.href = `/auth/logout?session_hint=${Cookies.get('session_hint')}`;
              }}
            >
              Logout
            </button>
          </div>
        </div>
      </nav>

      <div className="py-3 md:py-6">
        <div className="container px-4 mx-auto flex justify-center">
          <div className="w-full max-w-lg px-2 py-16 sm:px-0 mb-20">
            <div className='flex'>
              <p className="text-4xl text-white mb-3 font-bold" data-cyid="welcome-msg-box">Welcome {user?.email}</p>
            </div>
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
