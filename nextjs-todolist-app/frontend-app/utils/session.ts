import { authOptions } from "@/pages/api/auth/[...nextauth]";
import { getServerSession } from "next-auth";

export async function getNextAuthServerSession(context: any) {
  return await getServerSession(context.req, context.res, authOptions);
}
