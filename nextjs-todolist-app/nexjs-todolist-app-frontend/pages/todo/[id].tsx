import DefaultLayout from "@/layouts/default";
import { useRouter } from "next/router";
import { title, subtitle } from "@/components/primitives";
import { TodoResponse, listTodosForUser } from "@/svc/backend.client";

import { GetServerSideProps, InferGetServerSidePropsType } from "next";
import { redirectToLogin } from "@/utils/redirect";
import { getNextAuthServerSession } from "@/utils/session";

type TodoDetailPageProps = {
  todos: TodoResponse[];
};

export const getServerSideProps = (async (context: any) => {
  const session = await getNextAuthServerSession(context);
  if (!session) {
    return redirectToLogin();
  }
  const todos = await listTodosForUser((session as any)?.user?.id!);
  return { props: { todos } };
}) satisfies GetServerSideProps<TodoDetailPageProps>;

function TodoDetailPage({
  todos,
}: InferGetServerSidePropsType<typeof getServerSideProps>) {

  console.log(todos);
  const router = useRouter();
  const { id } = router.query;
  const filteredTodo = todos.find(todo => todo.id === Number(id));

  return (
    <DefaultLayout>
      <section className="flex flex-col items-left justify-center gap-4 py-8 md:py-10">
        <div className="inline-block max-w-lg text-left justify-center">
          <br />
          <h1 className={title()}>{filteredTodo?.title}</h1>
          <h4 className={subtitle({ class: "mt-4" })}>
            {filteredTodo?.description}
          </h4>
        </div>
      </section>
    </DefaultLayout>
  );
}

export default TodoDetailPage;
