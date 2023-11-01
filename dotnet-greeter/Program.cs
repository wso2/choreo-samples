using System;
using System.Net;

namespace GreeterApp
{
    class Program
    {
        static void Main(string[] args)
        {
            string host = "*";
            int port = 9090;
            string prefix = $"http://{host}:{port}/greeter/";

            var listener = new HttpListener();
            listener.Prefixes.Add(prefix);
            listener.Start();

            Console.WriteLine($"Greeter app is listening on {prefix}");

            while (true)
            {
                var context = listener.GetContext();
                var request = context.Request;
                var response = context.Response;

                if (request.HttpMethod == "GET" && request.Url.PathAndQuery.StartsWith("/greeter/greet"))
                {
                    var name = request.QueryString.Get("name");
                    var message = $"Hello {name}";

                    response.ContentType = "text/plain";
                    response.ContentLength64 = message.Length;

                    using (var output = response.OutputStream)
                    {
                        var buffer = System.Text.Encoding.UTF8.GetBytes(message);
                        output.Write(buffer, 0, buffer.Length);
                    }
                }
                else
                {
                    response.StatusCode = 404;
                }

                response.Close();
            }
        }
    }
}
