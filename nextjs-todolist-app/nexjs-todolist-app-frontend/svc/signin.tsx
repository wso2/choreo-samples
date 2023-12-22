import { getServerSession } from "next-auth";
import authOptions from "@/pages/api/auth/[...nextauth]";
import { GetServerSideProps } from "next";
import { useSession, signIn, signOut, getSession } from "next-auth/react";
import { redirectTo } from "@/utils/redirect";

export const getServerSideProps = (async (context: any) => {
  const session = await getSession(context.req);
  console.log("s" + session);
  if (session) {
    return redirectTo("/");
  }
  return { props: {} };
}) satisfies GetServerSideProps<{}>;

function SignInPage() {
  return (
    <>
      <h1>Sign In</h1>
      <button onClick={() => signIn()}>Sign In</button>
    </>
  );
}

export default SignInPage;
