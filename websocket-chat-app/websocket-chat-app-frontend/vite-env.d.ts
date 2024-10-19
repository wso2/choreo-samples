interface ImportMetaEnv {
    readonly VITE_APP_SIGN_IN_REDIRECT_URL: string;
    readonly VITE_APP_SIGN_OUT_REDIRECT_URL: string;
    readonly VITE_APP_CLIENT_ID: string;
    readonly VITE_APP_AUTH_URL: string;
    readonly VITE_APP_SERVER_URL: string;
   
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }