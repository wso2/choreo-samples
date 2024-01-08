import {
  Navbar as NextUINavbar,
  NavbarContent,
  NavbarBrand,
  NavbarItem,
  Avatar,
} from "@nextui-org/react";
import { FcTodoList } from "react-icons/fc";
import { signOut, useSession } from "next-auth/react";
import { link as linkStyles } from "@nextui-org/theme";
import { siteConfig } from "@/config/site";
import NextLink from "next/link";
import clsx from "clsx";

export const Navbar = () => {
  const { status } = useSession({ required: true });

  return (
    <NextUINavbar maxWidth="xl" position="sticky">
      <NavbarContent className="basis-1/5 sm:basis-full" justify="start">
        <NavbarBrand className="gap-3 max-w-fit">
          <NextLink className="flex justify-start items-center gap-1" href="/">
            <Avatar
              icon={<FcTodoList />}
              size="md"
              classNames={{
                base: "bg-gradient-to-br from-[#2fadff] to-[#2f45ff]]",
                icon: "text-black/80",
              }}
            />
            <p className="font-bold text-inherit">ToDo List</p>
          </NextLink>
        </NavbarBrand>
        <div className="hidden lg:flex gap-4 justify-start ml-2">
          {siteConfig.navItems.map((item) => (
            <NavbarItem key={item.href}>
              <NextLink
                className={clsx(
                  linkStyles({ color: "foreground" }),
                  "data-[active=true]:text-primary data-[active=true]:font-medium"
                )}
                color="foreground"
                href={item.href}
              >
                {item.label}
              </NextLink>
            </NavbarItem>
          ))}
        </div>
      </NavbarContent>
      <NavbarContent>
        <User />
      </NavbarContent>
    </NextUINavbar>
  );
};

function User() {
  const { data: session } = useSession();
  if (!session) {
    return null;
  }
  return (
    <>
      Signed in as {session?.user?.email} <br />
      <button onClick={() => signOut()}>Sign out</button>
    </>
  );
}
