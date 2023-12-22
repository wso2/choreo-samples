export type SiteConfig = typeof siteConfig;

export const siteConfig = {
  name: "TodoList App",
  description: "Manage your Todo Lists here!.",
  navItems: [
    {
      label: "Home",
      href: "/",
    },
    {
      label: "Profile",
      href: "/profile",
    },
    {
      label: "Todos",
      href: "/todos",
    },
  ],
};
