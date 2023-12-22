import DefaultLayout from "@/layouts/default";
import { useSession } from "next-auth/react";
import { title, subtitle } from "@/components/primitives";
import { Avatar, AvatarIcon } from "@nextui-org/react";

export default function ProfilePage() {
  const { data: session } = useSession();

  return (
    <DefaultLayout>
      <section className="flex flex-col items-center justify-center gap-4 py-8 md:py-10">
        <div className="inline-block max-w-lg text-center justify-center">
          <Avatar
            icon={<AvatarIcon />}
            size="lg"
            classNames={{
              base: "bg-gradient-to-br from-[#2fadff] to-[#2f45ff]]",
              icon: "text-black/80",
            }}
          />
          <br />
          <h1 className={title()}>This is the Profile Page.</h1>
          <h4 className={subtitle({ class: "mt-4" })}>
            Signed in as {session?.user?.email}
          </h4>
          <p> Your session expires at {session?.expires}</p>
        </div>
      </section>
    </DefaultLayout>
  );
}
