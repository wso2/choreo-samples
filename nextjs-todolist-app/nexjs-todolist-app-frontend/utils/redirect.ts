export function redirectTo(callbackPath: string) {
  const callbackUrl = `${process.env.NEXTAUTH_URL}${callbackPath}`;
  const encodedCallbackUrl = encodeURIComponent(callbackUrl);
  return {
    redirect: {
      destination: callbackPath,
      permanent: false,
    },
  };
}

export function redirectToLogin() {
  return redirectTo(`/api/auth/signin?callbackUrl=${encodeURIComponent("/")}`);
}
